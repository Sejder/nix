{ config, pkgs, lib, ... }:

let
  inherit (lib) mkOption types mkEnableOption;
in
{
  options.services.desktopenv = {
    hyprland = mkEnableOption "Enable hyprland Desktop";
    minimal = mkEnableOption "No desktop environment";
  };

  config = {
    assertions = [
      {
        assertion = (lib.length (lib.filter (x: x) [
          config.services.desktopenv.hyprland
          config.services.desktopenv.minimal
        ]) == 1);
        message = "Exactly one desktop environment must be enabled in assertions.desktopenv.*";
      }
    ];
  };
}
