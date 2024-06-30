# home-manager module of neovim setup
{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.programs.neovim.nvimdots;
  inherit (lib) flip warn const;
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.lists) optionals;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption literalExpression;
  inherit (lib.strings) concatStringsSep versionOlder versionAtLeast;
  inherit (lib.types) listOf coercedTo package functionTo;
in
{
  options = {
    programs.neovim = {
      nvimdots = {
        enable = mkEnableOption ''
          Activate "ayamir/nvimdots".
          Have a look at https://github.com/ayamir/nvimdots for details
        '';
        bindLazyLock = mkEnableOption ''
          Bind lazy-lock.json in your repository to $XDG_CONFIG_HOME/nvim.
          Very powerful in terms of keeping the environment consistent, but has the following side effects.
          You cannot update it even if you run the Lazy command, because it binds read-only.
          You need to remove lazy-lock.json before enabling this option if `mergeLazyLock` is set.
        '';
        mergeLazyLock = mkEnableOption ''
          Merges the managed lazy-lock.json with the existing one under $XDG_CONFIG_HOME/nvim if its hash has changed on activation.
          Upstream package version changes have high priority.
          This means changes to lazy-lock.json in the config directory (likely due to installing package) will be preserved.
          In other words, it achieves environment consistency while remaining adaptable to changes.
          You need to unlink lazy-lock.json before enabling this option if `bindLazyLock` is set.
          Please refer to the wiki for details on the behavior.
        '';
        setBuildEnv = mkEnableOption ''
          Sets environment variables that resolve build dependencies as required by `mason.nvim` and `nvim-treesitter`
          Environment variables are only visible to `nvim` and have no effect on any parent sessions.
          Required for NixOS.
        '';
        withBuildTools = mkEnableOption ''
          Include basic build tools like `gcc` and `pkg-config`.
          Required for NixOS.
        '';
        withHaskell = mkEnableOption ''
          Enable the Haskell compiler. Set to `true` to
          use Haskell plugins.
        '';
        extraHaskellPackages = mkOption {
          type =
            let
              fromType = listOf package;
            in
            coercedTo fromType
              (flip warn const ''
                Assigning a plain list to extraHaskellPackages is deprecated.
                       Please assign a function taking a package set as argument, so
                         extraHaskellPackages = [ pkgs.haskellPackages.xxx ];
                       should become
                         extraHaskellPackages = ps: [ ps.xxx ];
              '')
              (functionTo fromType);
          default = _: [ ];
          defaultText = literalExpression "ps: [ ]";
          example = literalExpression "hsPkgs: with hsPkgs; [ mtl ]";
          description = ''
            The extra Haskell packages required for your plugins to work.
            This option accepts a function that takes a Haskell package set as an argument,
            and selects the required Haskell packages from this package set.
            See the example for more info.
          '';
        };
        extraDependentPackages = mkOption {
          type = listOf package;
          default = [ ];
          example = literalExpression "[ pkgs.openssl ]";
          description = "Extra build depends to add `LIBRARY_PATH` and `CPATH`.";
        };
      };
    };
  };
  config =
    let
      # Inspired from https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/nix-ld.nix
      build-dependent-pkgs = builtins.filter (package: !package.meta.unsupported) [
        # manylinux
        pkgs.acl
        pkgs.attr
        pkgs.bzip2
        pkgs.curl
        pkgs.glibc
        pkgs.libsodium
        pkgs.libssh
        pkgs.libxml2
        pkgs.openssl
        pkgs.stdenv.cc.cc
        pkgs.stdenv.cc.cc.lib
        pkgs.systemd
        pkgs.util-linux
        pkgs.xz
        pkgs.zlib
        pkgs.zstd
        # Packages not included in `nix-ld`'s NixOSModule
        pkgs.glib
        pkgs.libcxx
      ]
      ++ cfg.extraDependentPackages;

      neovim-build-deps = pkgs.buildEnv {
        name = "neovim-build-deps";
        paths = build-dependent-pkgs;
        extraOutputsToInstall = [ "dev" ];
        pathsToLink = [ "/lib" "/include" ];
        ignoreCollisions = true;
      };

      buildEnv = [
        ''CPATH=''${CPATH:+''${CPATH}:}${neovim-build-deps}/include''
        ''CPLUS_INCLUDE_PATH=''${CPLUS_INCLUDE_PATH:+''${CPLUS_INCLUDE_PATH}:}:${neovim-build-deps}/include/c++/v1''
        ''LD_LIBRARY_PATH=''${LD_LIBRARY_PATH:+''${LD_LIBRARY_PATH}:}${neovim-build-deps}/lib''
        ''LIBRARY_PATH=''${LIBRARY_PATH:+''${LIBRARY_PATH}:}${neovim-build-deps}/lib''
        ''NIX_LD_LIBRARY_PATH=''${NIX_LD_LIBRARY_PATH:+''${NIX_LD_LIBRARY_PATH}:}${neovim-build-deps}/lib''
        ''PKG_CONFIG_PATH=''${PKG_CONFIG_PATH:+''${PKG_CONFIG_PATH}:}${neovim-build-deps}/include/pkgconfig''
      ];
    in
    mkIf cfg.enable {
      assertions = [
        {
          assertion = ! (cfg.bindLazyLock && cfg.mergeLazyLock);
          message = "bindLazyLock and mergeLazyLock cannot be enabled at the same time.";
        }
      ];
      xdg.configFile = {
        "nvim/init.lua".source = ../../init.lua;
        "nvim/lua".source = ../../lua;
        "nvim/snips".source = ../../snips;
        "nvim/tutor".source = ../../tutor;
      } // optionalAttrs cfg.bindLazyLock {
        "nvim/lazy-lock.json".source = ../../lazy-lock.json;
      } // optionalAttrs cfg.mergeLazyLock {
        "nvim/lazy-lock.fixed.json" = {
          source = ../../lazy-lock.json;
          onChange = ''
            if [ -f ${config.xdg.configHome}/nvim/lazy-lock.json ]; then
              tmp=$(mktemp)
              ${pkgs.jq}/bin/jq -r -s '.[0] * .[1]' ${config.xdg.configHome}/nvim/lazy-lock.json ${config.xdg.configFile."nvim/lazy-lock.fixed.json".source} > "''${tmp}" && mv "''${tmp}" ${config.xdg.configHome}/nvim/lazy-lock.json
            else
              ${pkgs.rsync}/bin/rsync --chmod 644 ${config.xdg.configFile."nvim/lazy-lock.fixed.json".source} ${config.xdg.configHome}/nvim/lazy-lock.json
            fi
          '';
        };
      };
      home = {
        packages = [
          pkgs.ripgrep
        ];
        shellAliases = optionalAttrs (cfg.setBuildEnv && (versionOlder config.home.stateVersion "24.05")) {
          nvim = concatStringsSep " " buildEnv + " nvim";
        };
      };
      programs.neovim = {
        enable = true;

        withNodeJs = true;
        withPython3 = true;

        extraPackages = [
          # Dependent packages used by default plugins
          pkgs.doq
          pkgs.tree-sitter
        ]
        ++ optionals cfg.withBuildTools [
          pkgs.cargo
          pkgs.clang
          pkgs.cmake
          pkgs.gcc
          pkgs.gnumake
          pkgs.go
          pkgs.lua51Packages.luarocks
          pkgs.ninja
          pkgs.pkg-config
          pkgs.yarn
        ]
        ++ optionals cfg.withHaskell [
          (pkgs.writeShellApplication {
            name = "stack";
            text = ''
              exec "${pkgs.stack}/bin/stack" "--extra-include-dirs=${config.home.profileDirectory}/lib/nvim-depends/include" "--extra-lib-dirs=${config.home.profileDirectory}/lib/nvim-depends/lib" "$@"
            '';
          })
          (pkgs.haskellPackages.ghcWithPackages (ps: cfg.extraHaskellPackages ps))
        ];

        extraPython3Packages = ps: with ps; [
          docformatter
          isort
          pynvim
        ];
      }
      // optionalAttrs (versionAtLeast config.home.stateVersion "24.05") {
        extraWrapperArgs = optionals cfg.setBuildEnv [
          "--suffix"
          "CPATH"
          ":"
          "${neovim-build-deps}/include"
          "--suffix"
          "CPLUS_INCLUDE_PATH"
          ":"
          "${neovim-build-deps}/include/c++/v1"
          "--suffix"
          "LD_LIBRARY_PATH"
          ":"
          "${neovim-build-deps}/lib"
          "--suffix"
          "LIBRARY_PATH"
          ":"
          "${neovim-build-deps}/lib"
          "--suffix"
          "PKG_CONFIG_PATH"
          ":"
          "${neovim-build-deps}/include/pkgconfig"
          "--suffix"
          "NIX_LD_LIBRARY_PATH"
          ":"
          "${neovim-build-deps}/lib"
        ];
      };
    };
}
