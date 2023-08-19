{
  # This provides only NixOS module
  # As of 2023/08/19, you need to depend on nixpkgs-unstable.
  # because "doq" is not included in the stable version.
  description = "Provide nixosModules for ayamir/nvimdots";

  inputs = { };

  outputs = inputs: {
    nixosModules = {
      nvimdots = ./nixos;
    };
  };
}
