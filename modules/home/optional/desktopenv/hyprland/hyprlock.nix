{ config, lib, ... }:

let
  cfg = config.features.desktopenv.hyprland.hyprlock;
in
{
  config = lib.mkIf cfg.enable {
    programs.hyprlock.enable = true;
  };
}