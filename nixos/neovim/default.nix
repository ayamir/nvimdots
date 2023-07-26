# home-manager module of neovim setup 
{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.programs.neovim.activateNvimDots;
in
{
  options = {
    programs.neovim = {
      activateNvimDots = {
        enable = mkEnableOption ''
          Activate "ayamir/nvimdots".
          Please see details https://github.com/ayamir/nvimdots
        '';
        withDeno = mkEnableOption ''
          Enable Deno provider. Set to `true` to 
          use Deno plugins.
        '';
        withDotNET = mkEnableOption ''
          Enable dotnet provider. Set to `true` to 
          use DotNET plugins.
        '';
        withErlang = mkEnableOption ''
          Enable Erlang provider. Set to `true` to 
          use Erlang plugins.
        '';
        withGo = mkEnableOption ''
          Enable Go provider. Set to `true` to 
          use Go plugins.
        '';
        withHaskell = mkEnableOption ''
          Enable Haskell compiler. Set to `true` to
          use Haskell plugins.
        '';
        withHaxe = mkEnableOption ''
          Enable Haxe provider. Set to `true` to 
          use Haxe plugins.
        '';
        withJava = mkEnableOption ''
          Enable Java provider. Set to `true` to
          use Java plugins.
        '';
        withJulia = mkEnableOption ''
          Enable Julia provider. Set to `true` to
          use Julia plugins.
        '';
        withNim = mkEnableOption ''
          Enable nim provider. Set to `true` to 
          use nim plugins.
        '';
        withOpam = mkEnableOption ''
          Enable Opam provider. Set to `true` to 
          use Opam plugins.
        '';
        withPHP = mkEnableOption ''
          Enable PHP provider. Set to `true` to 
          use PHP plugins.
        '';
        withR = mkEnableOption ''
          Enable R provider. Set to `true` to 
          use R plugins.
        '';
        withRust = mkEnableOption ''
          Enable Rust provider. Set to `true` to 
          use Rust plugins.
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
      # From https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/nix-ld.nix
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
          glib
          clangStdenv.cc
        ]
        ++ cfg.extraDependentPackages
        ++ optional cfg.withGo hunspell
        ++ optionals cfg.withVala [ vala jsonrpc-glib ];

      makePkgConfigPath = x: makeSearchPathOutput "dev" "lib/pkgconfig" x;
      makeIncludePath = x: makeSearchPathOutput "dev" "include" x;

      library-pkgs = pkgs.buildEnv {
        name = "library-pkgs";
        pathsToLink = [ "/lib" ];
        paths = map lib.getLib build-dependent-pkgs;
        ignoreCollisions = true;
      };
      include-pkgs = pkgs.buildEnv {
        name = "include-pkgs";
        extraPrefix = "/lib/include";
        paths = splitString ":" (makeIncludePath build-dependent-pkgs);
        ignoreCollisions = true;
      };
      pkg-config-pkgs = pkgs.buildEnv {
        name = "pkg-config-pkgs";
        extraPrefix = "/lib/pkgconfig";
        paths = splitString ":" (makePkgConfigPath build-dependent-pkgs);
        ignoreCollisions = true;
      };
    in
    mkIf cfg.enable
      {
        xdg = {
          configFile = {
            "nvim/lua".source = ../../lua;
            "nvim/init.lua".source = ../../init.lua;
          };
        };
        home.packages = [ library-pkgs include-pkgs pkg-config-pkgs ];
        home.shellAliases.nvim = "SQLITE_CLIB_PATH=${pkgs.sqlite.out}/lib/libsqlite3.so PKG_CONFIG_PATH=${config.home.profileDirectory}/lib/pkgconfig CPATH=${config.home.profileDirectory}/lib/include LIBRARY_PATH=${config.home.profileDirectory}/lib LD_LIBRARY_PATH=${config.home.profileDirectory}/lib:''$NIX_LD_LIBRARY_PATH nvim";

        programs.java.enable = cfg.withJava;
        programs.dotnet.enable = cfg.withDotNET;

        programs.neovim = {
          enable = true; # Replace from vi&vim to neovim
          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;

          withNodeJs = true;
          withPython3 = true;
          withRuby = true;

          extraPackages = with pkgs;
            [
              # Build Dependent
              pkg-config
              clang
              gcc
              cmake
              gnumake
              ninja

              # Dependent packages used by default plugins
              doq
              neovim-remote
              ripgrep
              sqlite
              xclip

              yarn
            ]
            ++ optional cfg.withDeno deno
            ++ optional cfg.withErlang rebar3
            ++ optional cfg.withGo go
            ++ optionals cfg.withHaskell [
              ghc
              (pkgs.writeShellApplication {
                name = "stack";
                text = ''
                  exec "${pkgs.stack}/bin/stack" "--extra-include-dirs=${config.home.profileDirectory}/lib/include" "--extra-lib-dirs=${config.home.profileDirectory}/lib" "$@"
                '';
              })
              (haskellPackages.ghcWithPackages (ps: [
                # ghcup
              ] ++ cfg.extraHaskellPackages pkgs.haskellPackages))
            ]
            ++ optional cfg.withHaxe haxe
            ++ optional cfg.withJulia julia-bin
            ++ optional cfg.withNim nim
            ++ optional cfg.withOpam opam
            ++ optionals cfg.withPHP [
              php
              phpPackages.composer # php
            ]
            ++ optional cfg.withR (rWrapper.override {
              packages = with pkgs.rPackages;
                [ xml2 lintr roxygen2 ]
                ++ cfg.extraRPackages pkgs.rPackages;
            })
            ++ optional cfg.withRust cargo
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
