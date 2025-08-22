{ config, pkgs, lib, ... }:
let
  cfg = config.features.desktopenv.hyprland;
in
{
  options.features.desktopenv.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.home-manager.users.mikke.features.desktopenv.hyprland.enable;
      description = "Enable hyprland";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    services.displayManager.defaultSession = "hyprland-uwsm";

    features.displayManagers.sddm.enable = true;

    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [
      bluez
    ];
  };
}

