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
        withDotnet = mkEnableOption ''
          Enable dotnet provider. Set to `true` to 
          use dotnet plugins.
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
        extraPkgConfigPackages = mkOption {
          type = with types; listOf package;
          default = [ ];
          example = literalExpression "[ pkgs.openssl ]";
          description = "Extra build dependent for pkgconfig.";
        };
        extraBuildDependentPackages = mkOption {
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
      enabledBash = config.programs.bash.enable; # 
      enabledFish = config.programs.fish.enable; # shellInit set -x
      enabledIon = config.programs.ion.enable; # initExtra export PATH
      enabledNushell = config.programs.nushell.enable; # environmentVariables
      enabledZsh = config.programs.zsh.enable;

      pkg-config-pkgs = with pkgs; [ openssl zlib ]
        ++ optional cfg.withGo hunspell
        ++ optionals cfg.withR [ libxml2 glib ]
        ++ optional cfg.withVala vala
        ++ optionals (cfg.extraPkgConfigPackages != [ ]) cfg.extraPkgConfigPackages;

      include-pkgs = with pkgs; [ openssl zlib ]
        ++ optional cfg.withGo hunspell
        ++ optionals (cfg.extraBuildDependentPackages != [ ]) cfg.extraBuildDependentPackages;

      lib-pkgs = with pkgs; [ openssl zlib ]
        ++ optional cfg.withVala vala
        ++ optionals (cfg.extraBuildDependentPackages != [ ]) cfg.extraBuildDependentPackages;

      sessionVariables =
        let
          makePkgConfigPath = x: makeSearchPathOutput "dev" "lib/pkgconfig" x;
          makeIncludePath = x: makeSearchPathOutput "dev" "include" x;
        in
        {
          # "*".sessionVariables"."*_PATH" = mkAfter (cfg.*.sessionVariables."*_PATH" + ":${pkgs.zlib}/lib"), if you add path to `*_PATH`.
          SQLITE_CLIB_PATH = "${pkgs.sqlite.out}/lib/libsqlite3.so";
          PKG_CONFIG_PATH = makePkgConfigPath pkg-config-pkgs;
          CPATH = makeIncludePath include-pkgs;
          LIBRARY_PATH = makeLibraryPath lib-pkgs;
        }; # "*".sessionVariables.DOTNET = mkAfter "${pkgs.dotnet-sdk}", if you override `DOTNET_ROOT`.
    in
    mkIf cfg.enable
      {
        xdg = {
          configFile = {
            "nvim/lua".source = ../../lua;
            "nvim/init.lua".source = ../../init.lua;
          };
        };
        # export build dependent pathes
        # Reflecting `home.sessionVariables` requires GUI logout, so set it in each shell
        programs.bash.sessionVariables = mkBefore sessionVariables;
        programs.fish.shellInit = mkBefore (concatStringsSep "\n" (mapAttrsToList (k: v: "set -x ${k} ${v}") sessionVariables));
        programs.ion.initExtra = mkBefore (concatStringsSep "\n" (mapAttrsToList (k: v: "export ${k}=${v}") sessionVariables));
        programs.nushell.environmentVariables = mkBefore sessionVariables;
        programs.zsh.sessionVariables = mkBefore sessionVariables;
        home.sessionVariables = optionalAttrs (! enabledBash && enabledFish && enabledIon && enabledNushell && enabledZsh) sessionVariables;

        programs.java.enable = cfg.withJava;

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
                  exec "${pkgs.stack}/bin/stack" "--extra-include-dirs=${pkgs.zlib.dev}/include" "--extra-lib-dirs=${pkgs.zlib}/lib" "$@"
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
