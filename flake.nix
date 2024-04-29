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
            testEnv = (import ./nixos/test.nix { inherit inputs pkgs; }).activationPackage;
          };
          devshells.default = {
            commands = [
              {
                help = "neovim with nvimdots";
                name = "nvim";
                command = ''
                  ${self.packages.${system}.testEnv}/home-path/bin/nvim
                '';
              }
            ];
            devshell = {
              motd = ''
                {202}🔨 Welcome to devshell{reset}
                Symlink configs to "''${XDG_CONFIG_HOME}"/nvimdots!
                Seted NVIM_APPNAME=nvimdots, so neovim will put file under "\$XDG_xxx_HOME"/nvimdots.
                To uninstall, remove "\$XDG_xxx_HOME"/nvimdots.

                $(type -p menu &>/dev/null && menu)
              '';
              startup = {
                mkNvimDir = {
                  text = ''
                    mkdir -p "''${XDG_CONFIG_HOME}"/nvimdots
                    for path in init.lua lua snips tutor; do
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
