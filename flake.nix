{
  # This provides only NixOS module
  # As of 2023/08/19, you need to depend on nixpkgs-unstable.
  # because "doq" is not included in the stable version.
  description = "Provide nixosModules for ayamir/nvimdots";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
      {
        imports = [
          inputs.devshell.flakeModule
        ];
        flake = {
          homeManagerModules = {
            nvimdots = ./nixos;
          };
        };
        systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
        perSystem = { pkgs, system, ... }: {
          packages = {
            testEnv = (import ./nixos/testEnv.nix { inherit inputs pkgs; }).activationPackage;
            check-linker = pkgs.writeShellApplication {
              name = "check-linker";
              text =
                let
                  ldd_cmd = if pkgs.stdenv.isDarwin then "xcrun otool -L" else "${pkgs.glibc.bin}/bin/ldd";
                in
                ''
                  #shellcheck disable=SC1090
                  source <(sed -ne :1 -e 'N;1,1b1' -e 'P;D' "${self.packages.${system}.testEnv}/home-path/bin/nvim")
                  echo "Checking files under ''${XDG_DATA_HOME}/''${NVIM_APPNAME:-nvim}/mason/bin..."
                  find "''${XDG_DATA_HOME}/''${NVIM_APPNAME:-nvim}/mason/bin" -type l | while read -r link; do
                    "${ldd_cmd}" "$(readlink -f "$link")" > /dev/zero 2>&1 || continue
                    linkers=$("${ldd_cmd}" "$(readlink -f "$link")" | tail -n+2)
                    echo "$linkers" | while read -r line; do
                      [ -z "$line" ] && continue
                      echo "$line" | grep -q "/nix/store" || printf '%s: %s does not link to /nix/store \n' "$(basename "$link")" "$line"
                    done
                  done
                  echo "*** Done ***"
                '';
            };
          };
          devshells.default = {
            commands = [
              {
                help = "neovim linked to testEnv.";
                name = "nvim";
                command = ''
                  ${self.packages.${system}.testEnv}/home-path/bin/nvim
                '';
              }
              {
                help = "check-linker";
                package = self.packages.${system}.check-linker;
              }
            ];
            devshell = {
              motd = ''
                {202}🔨 Welcome to devshell{reset}
                Symlink configs to "''${XDG_CONFIG_HOME}"/nvimdots!
                And NVIM_APPNAME=nvimdots is already configured, so neovim will put files under "\$XDG_xxx_HOME"/nvimdots.
                To uninstall, remove "\$XDG_xxx_HOME"/nvimdots.

                $(type -p menu &>/dev/null && menu)
              '';
              startup = {
                mkNvimDir = {
                  text = ''
                    mkdir -p "''${XDG_CONFIG_HOME}"/nvimdots
                    for path in lazy-lock.json init.lua lua snips tutor; do
                      ln -sf "''${PWD}/''${path}" "''${XDG_CONFIG_HOME}"/nvimdots/
                    done
                  '';
                };
              };
            };
            env = [
              {
                name = "NVIM_APPNAME";
                value = "nvimdots";
              }
              {
                name = "PATH";
                prefix = "${self.packages.${system}.testEnv}/home-path/bin";
              }
            ];
            packages = with pkgs; [
              nixd
              nixpkgs-fmt
            ];
          };
        };
      };
}
