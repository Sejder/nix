{ config, pkgs, lib, ... }:

let
  cfg = config.features.desktopenv.gnome;
in
{
  options.features.desktopenv.gnome = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default =
        let
          users = config.systemUsers.users or ["mikke"];
          anyUserHasGnome = lib.any (user:
            config.home-manager.users.${user}.features.desktopenv.gnome.enable or false
          ) users;
        in
          anyUserHasGnome;
      description = "Enable GNOME desktop environment";
    };
  };
  
  config = lib.mkIf cfg.enable {
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;
    services.xserver.enable = true;
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;
    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = config.systemUsers.primaryUser;

    # Disable power-profiles-daemon to avoid conflict with TLP
    services.power-profiles-daemon.enable = false;
  };
}