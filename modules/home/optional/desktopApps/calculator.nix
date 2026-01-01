{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.features.desktopApps.calculator;
in
{
  options.features.desktopApps.calculator = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Calculator app";
    };
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      qalculate-gtk
    ];
  };
}
