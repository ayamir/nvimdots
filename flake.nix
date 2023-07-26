{
  # This provides only NixOS module
  # As of 2023/07/24, you need to depend on nixpkgs-unstable.
  # because "doq" is not included in the stable version.
  description = "Provide home-manager module for ayamir/neovim";

  inputs = { };

  outputs = inputs: {
    nixosModules = {
      for-hm = ./nixos;
    };
  };
}
