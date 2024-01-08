# NOTE: to add more language support, make a directory under `nixos`, followed by the language name and `default.nix`. See `dotnet/default.nix` for example.
{
  imports = [
    ./dotnet
    ./neovim
  ];
}
