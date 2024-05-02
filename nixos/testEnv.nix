{ inputs, pkgs, ... }:
let
  testSettings = {
    home = {
      username = "hm-user";
      homeDirectory = "/home/hm-user";
      stateVersion = "24.05";
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
