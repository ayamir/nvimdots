# home-manager module of neovim setup
{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.programs.neovim.nvimdots;
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
          type = with types;
            let fromType = listOf package;
            in coercedTo fromType
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
          type = with types; listOf package;
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
      build-dependent-pkgs = with pkgs; builtins.filter (package: !package.meta.unsupported) [
        # manylinux
        acl
        attr
        bzip2
        curl
        glibc
        libsodium
        libssh
        libxml2
        openssl
        stdenv.cc.cc
        stdenv.cc.cc.lib
        systemd
        util-linux
        xz
        zlib
        zstd
        # Packages not included in `nix-ld`'s NixOSModule
        glib
        libcxx
      ]
      ++ cfg.extraDependentPackages;

      makePkgConfigPath = x: makeSearchPathOutput "dev" "lib/pkgconfig" x;
      makeIncludePath = x: makeSearchPathOutput "dev" "include" x;

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
      xdg.configFile = {
        "nvim/init.lua".source = ../../init.lua;
        "nvim/lua".source = ../../lua;
        "nvim/snips".source = ../../snips;
        "nvim/tutor".source = ../../tutor;
      } // lib.optionalAttrs cfg.bindLazyLock {
        "nvim/lazy-lock.json".source = ../../lazy-lock.json;
      };
      home = {
        packages = with pkgs; [
          ripgrep
        ];
        shellAliases = optionalAttrs (cfg.setBuildEnv && (lib.versionOlder config.home.stateVersion "24.05")) {
          nvim = concatStringsSep " " buildEnv + " nvim";
        };
      };
      programs.neovim = {
        enable = true;

        withNodeJs = true;
        withPython3 = true;

        extraPackages = with pkgs;
          [
            # Dependent packages used by default plugins
            doq
            tree-sitter
          ]
          ++ optionals cfg.withBuildTools [
            cargo
            clang
            cmake
            gcc
            gnumake
            go
            lua51Packages.luarocks
            ninja
            pkg-config
            yarn
          ]
          ++ optionals cfg.withHaskell [
            (pkgs.writeShellApplication {
              name = "stack";
              text = ''
                exec "${pkgs.stack}/bin/stack" "--extra-include-dirs=${config.home.profileDirectory}/lib/nvim-depends/include" "--extra-lib-dirs=${config.home.profileDirectory}/lib/nvim-depends/lib" "$@"
              '';
            })
            (haskellPackages.ghcWithPackages (ps: cfg.extraHaskellPackages ps))
          ];

        extraPython3Packages = ps: with ps; [
          docformatter
          isort
          pynvim
        ];
      }
      // lib.optionalAttrs (lib.versionAtLeast config.home.stateVersion "24.05") {
        extraWrapperArgs = lib.optionals cfg.setBuildEnv [
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
