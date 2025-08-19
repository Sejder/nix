{ config, lib, ...}:

let
  cfg = config.features.desktopenv.hyprland.hypridle;
in
{
  config = lib.mkIf cfg.enable {
    services.hypridle.enable = true;
  };
}