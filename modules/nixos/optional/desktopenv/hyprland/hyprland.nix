{ config, pkgs, lib, ... }:
let
  cfg = config.features.desktopenv.hyprland;
in
{
  options.features.desktopenv.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.home-manager.users.mikke.features.desktopenv.hyprland;
      description = "Enable hyprland";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

  };
}

