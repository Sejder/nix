{ config, pkgs, lib, ... }:
let
  cfg = config.features.desktopenv.hyprland;
in
{
  options.features.desktopenv.hyprland = {
    enable = lib.mkEnableOption "Hyprland";

    #waybar.enable = lib.mkOption {
    #  type = lib.types.bool;
    #  default = cfg.enable;
    #  description = "Enable waybar";
    #};

    #hypridle.enable = lib.mkOption {
    #  type = lib.types.bool;
    #  default = cfg.enable;
    #  description = "Enable Hypridle";
    #};

    #hyprlock.enable = lib.mkOption {
    #  type = lib.types.bool;
    #  default = cfg.enable;
    #  description = "Enable Hyprlock";
    #};

    #kitty.enable = lib.mkOption {
    #  type = lib.types.bool;
    #  default = cfg.enable;
    #  description = "Enable Kitty";
    #};
  };

  config = lib.mkIf cfg.enable {

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

  };
}

