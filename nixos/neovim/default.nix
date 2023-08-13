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
          Please see details https://github.com/ayamir/nvimdots
        '';
        setBuildEnv = mkEnableOption ''
          Sets environment variables that resolve build dependencies needed by `mason.nvim` and `nvim-treesitter`
          Environment variables are only visible to `nvim` and have no effect on the session.
          Required for NixOS.
        '';
        withBuildTools = mkEnableOption ''
          Include basic build tools like `gcc` and `pkg-config`.
          Required for NixOS.
        '';
        withDotNET = mkEnableOption ''
          Enable dotnet provider. Set to `true` to
          use DotNET plugins.
        '';
        withGo = mkEnableOption ''
          Enable Go provider. Set to `true` to
          use Go plugins.
        '';
        withHaskell = mkEnableOption ''
          Enable Haskell compiler. Set to `true` to
          use Haskell plugins.
        '';
        withJava = mkEnableOption ''
          Enable Java provider. Set to `true` to
          use Java plugins.
        '';
        withPHP = mkEnableOption ''
          Enable PHP provider. Set to `true` to
          use PHP plugins.
        '';
        withR = mkEnableOption ''
          Enable R provider. Set to `true` to
          use R plugins.
        '';
        withVala = mkEnableOption ''
          Enable Vala provider. Set to `true` to
          use Vala plugins.
        '';
        extraRPackages = mkOption {
          type = with types;
            let fromType = listOf package;
            in
            coercedTo fromType
              (flip warn const ''
                Assigning a plain list to extraRPackages is deprecated.
                       Please assign a function taking a package set as argument, so
                         extraRPackages = [ pkgs.rPackages.xxx ];
                       should become
                         extraRPackages = rPkgs: with rPkgs; [ xxx ];
              '')
              (functionTo fromType);
          default = _: [ ];
          defaultText = literalExpression "ps: [ ]";
          example =
            literalExpression "rPkgs: with rPkgs; [ xml2 ]";
          description = ''
            The extra R packages required for your plugins to work.
            This option accepts a function that takes a R package set as an argument,
            and selects the required R packages from this package set.
            See the example for more info.
          '';
        };
        extraHaskellPackages = mkOption {
          type = with types;
            let fromType = listOf package;
            in
            coercedTo fromType
              (flip warn const ''
                Assigning a plain list to extraRPackages is deprecated.
                    Please assign a function taking a package set as argument, so
                        extraHaskellPackages = [ pkgs.haskellPackages.xxx ];
                    should become
                        extraHaskellPackages = hsPkgs: with hsPkgs; [ xxx ];
              '')
              (functionTo fromType);
          default = _: [ ];
          defaultText = literalExpression "ps: [ ]";
          example =
            literalExpression "hsPkgs: with hsPkgs; [ haskell-language-server ]";
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
      build-dependent-pkgs = with pkgs;
        [
          zlib
          zstd
          stdenv.cc.cc
          curl
          openssl
          attr
          libssh
          bzip2
          libxml2
          acl
          libsodium
          util-linux
          xz
          systemd
          # Packages not included in `nix-ld`'s NixOSModule
          glib
          libcxx
        ]
        ++ cfg.extraDependentPackages
        ++ optional cfg.withGo hunspell
        ++ optionals cfg.withVala [ vala jsonrpc-glib ];

      makePkgConfigPath = x: makeSearchPathOutput "dev" "lib/pkgconfig" x;
      makeIncludePath = x: makeSearchPathOutput "dev" "include" x;

      nvim-depends-library = pkgs.buildEnv {
        name = "nvim-depends-library";
        paths = map lib.getLib build-dependent-pkgs;
        extraPrefix = "/lib/nvim-depends";
        pathsToLink = [ "/lib" ];
        ignoreCollisions = true;
      };
      nvim-depends-include = pkgs.buildEnv {
        name = "nvim-depends-include";
        paths = splitString ":" (makeIncludePath build-dependent-pkgs);
        extraPrefix = "/lib/nvim-depends/include";
        ignoreCollisions = true;
      };
      nvim-depends-pkgconfig = pkgs.buildEnv {
        name = "nvim-depends-pkgconfig";
        paths = splitString ":" (makePkgConfigPath build-dependent-pkgs);
        extraPrefix = "/lib/nvim-depends/pkgconfig";
        ignoreCollisions = true;
      };
      buildEnv = [
        "CPATH=${config.home.profileDirectory}/lib/nvim-depends/include"
        "CPLUS_INCLUDE_PATH=${config.home.profileDirectory}/lib/nvim-depends/include/c++/v1"
        "LD_LIBRARY_PATH=${config.home.profileDirectory}/lib/nvim-depends/lib"
        "LIBRARY_PATH=${config.home.profileDirectory}/lib/nvim-depends/lib"
        "NIX_LD_LIBRARY_PATH=${config.home.profileDirectory}/lib/nvim-depends/lib"
        "PKG_CONFIG_PATH=${config.home.profileDirectory}/lib/nvim-depends/pkgconfig"
      ];
    in
    mkIf cfg.enable
      {
        xdg.configFile = {
          "nvim/init.lua".source = ../../init.lua;
          "nvim/lua".source = ../../lua;
          "nvim/snips".source = ../../snips;
          "nvim/tutor".source = ../../tutor;
        };
        home.packages = with pkgs; [
          ripgrep
        ] ++ optionals cfg.setBuildEnv [ patchelf nvim-depends-library nvim-depends-include nvim-depends-pkgconfig ];
        home.extraOutputsToInstall = optional cfg.setBuildEnv "nvim-depends";
        home.shellAliases.nvim = optionalString cfg.setBuildEnv (concatStringsSep " " buildEnv) + " SQLITE_CLIB_PATH=${pkgs.sqlite.out}/lib/libsqlite3.so " + "nvim";

        programs.java.enable = cfg.withJava;
        programs.dotnet.dev.enable = cfg.withDotNET;

        programs.neovim = {
          enable = true;
          viAlias = true; # Replace from vi&vim to neovim
          vimAlias = true;
          vimdiffAlias = true;

          withNodeJs = true;
          withPython3 = true;
          withRuby = true;

          extraPackages = with pkgs;
            [
              # Dependent packages used by default plugins
              doq
              sqlite
            ]
            ++ optionals cfg.withBuildTools [
              pkg-config
              clang
              gcc
              cmake
              gnumake
              ninja
              cargo
              yarn
            ]
            ++ optional cfg.withGo go
            ++ optionals cfg.withHaskell [
              ghc
              (pkgs.writeShellApplication {
                name = "stack";
                text = ''
                  exec "${pkgs.stack}/bin/stack" "--extra-include-dirs=${config.home.profileDirectory}/lib/nvim-depends/include" "--extra-lib-dirs=${config.home.profileDirectory}/lib/nvim-depends/lib" "$@"
                '';
              })
              (haskellPackages.ghcWithPackages (ps: [
                # ghcup # ghcup is broken
              ] ++ cfg.extraHaskellPackages pkgs.haskellPackages))
            ]
            ++ optionals cfg.withPHP [
              php
              phpPackages.composer # php
            ]
            ++ optional cfg.withR (rWrapper.override {
              packages = with pkgs.rPackages;
                [ xml2 lintr roxygen2 ]
                ++ cfg.extraRPackages pkgs.rPackages;
            })
            ++ optionals cfg.withVala [ meson vala ];

          extraPython3Packages = ps: with ps; [
            isort
            docformatter
            pynvim
          ];
          extraLuaPackages = ls: with ls; [
            luarocks
          ];
        };
      };
}
