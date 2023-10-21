# This module provides DOTNET_ROOT, with a different way to install dotnet locally.
# This module is modified from the NixOS module `programs.dotnet`

{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.dotnet.dev;
in
{
  options = {
    programs.dotnet.dev = {
      enable = mkEnableOption "" // {
        description = ''
          Install the DotNet runtime and set the
          {env}`DOTNET_ROOT` variable.
        '';
      };
      environmentVariables = mkOption {
        type = with types; lazyAttrsOf (oneOf [ str path int float ]);
        default = { };
        example = { DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "0"; };
        description = ''
          An attribute set an environment variable for DotNET.
        '';
      };
      package = mkOption {
        type = types.package;
        default = pkgs.dotnet-sdk_7;
        defaultText = literalExpression "pkgs.dotnet-sdk_7";
        description = "DotNET package to install.";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    # Please see https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-environment-variables#dotnet_root-dotnet_rootx86
    home.sessionVariables = {
      DOTNET_ROOT = "${cfg.package}";
    } // cfg.environmentVariables;
  };
}
