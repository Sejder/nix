{ config, pkgs, lib, ... }:
let
  cfg = config.features.desktopenv.hyprland;
in
{
  options.features.desktopenv.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default =
        let
          users = config.systemUsers.users or ["mikke"];
          anyUserHasHyprland = lib.any (user:
            config.home-manager.users.${user}.features.desktopenv.hyprland.enable or false
          ) users;
        in
          anyUserHasHyprland;
      description = "Enable hyprland";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    services.displayManager.defaultSession = "hyprland";

    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [
      bluez
    ];

    features = {
      displayManagers.sddm.enable = true;
      displayManagers.autoLogin.enable = true;
      fileManagers.nautilus.enable = true;
    };
  };
}

