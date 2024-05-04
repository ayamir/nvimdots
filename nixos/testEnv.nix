{ inputs, pkgs, ... }:
let
  testSettings = { config, ... }: {
    warnings = [
      "home-manager version: ${config.home.version.release}"
    ];
    home = {
      username = "hm-user";
      homeDirectory = "/home/hm-user";
      stateVersion = config.home.version.release;
    };
    xdg.enable = true;
    programs = {
      home-manager.enable = true;
      git.enable = true;
      neovim = {
        enable = true;
        nvimdots = {
          enable = true;
          setBuildEnv = true;
          withBuildTools = true;
          withHaskell = true;
        };
      };
    };
  };
in
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [
    ./default.nix
    testSettings
  ];
}
