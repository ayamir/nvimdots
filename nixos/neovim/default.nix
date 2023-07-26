#  neovim conf
#  I use conf sourcing ./nvim but you can manager from home manager.
{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.programs.neovim.activateNvimDots;
  makePkgConfigPath = x: makeSearchPathOutput "dev" "lib/pkgconfig" x;
  makeIncludePath = x: makeSearchPathOutput "dev" "include" x;
in
{
  options = {
    programs.neovim = {
      activateNvimDots = {
        enable = mkEnableOption ''
          My nvim config
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    xdg = {
      configFile = {
        "nvim/lua".source = ../../lua; # windowsとconfigを共有するため.config/nvimで管理する
        "nvim/init.lua".source = ../../init.lua;
        "nvim/nixos".source = ../../nixos;
      };
    };
    home.sessionVariables = {
      SQLITE_CLIB_PATH = "${pkgs.sqlite.out}/lib/libsqlite3.so";
      PKG_CONFIG_PATH = makePkgConfigPath (with pkgs; [ openssl hunspell zlib vala libxml2 glib ]);
      CPATH = makeIncludePath (with pkgs; [ openssl hunspell ]);
      LIBRARY_PATH = makeLibraryPath (with pkgs; [ openssl vala ]);
      DOTNET_ROOT = "${pkgs.dotnet-sdk_7}";
    };
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
          xclip

          pkg-config
          gcc
          clang
          cmake
          gnumake
          ninja

          sqlite
          deno
          openssl

          ripgrep

          neovim-remote
        ]
        ++ [
          rebar3 # for erlang-ls
          hunspell # for gospell
          (pkgs.writeShellApplication {
            name = "stack";
            text = ''
              exec "${pkgs.stack}/bin/stack" "--extra-include-dirs=${pkgs.zlib.dev}/include" "--extra-lib-dirs=${pkgs.zlib}/lib" "$@"
            '';
          })
          ghc # haskell
          # haskellPackages.ghcup
          luarocks # lua
          phpPackages.composer # php
          php #php
          cargo # rust
          yarn # npm
          go # go
          openjdk19 # java
          julia-bin # julia
          dotnet-sdk_7 # dotnet
          nim # nim
          opam # opam
          (rWrapper.override { packages = with pkgs.rPackages; [ xml2 lintr roxygen2 ]; }) # R
          meson # vala-language-server
          vala # vala-language-server
          # haxe # haxe
        ];

      extraPython3Packages = ps:
        with ps; [
          isort
          docformatter
          doq
          pynvim
          pip
        ];
    };
  };
}
