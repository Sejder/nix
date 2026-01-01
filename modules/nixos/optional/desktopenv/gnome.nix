{
  config,
  lib,
  ...
}:

let
  cfg = config.features.desktopenv.gnome;
in
{
  options.features.desktopenv.gnome = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default =
        let
          users = config.systemUsers.users or [ "mikke" ];
          anyUserHasGnome = lib.any (
            user: config.home-manager.users.${user}.features.desktopenv.gnome.enable or false
          ) users;
        in
        anyUserHasGnome;
      description = "Enable GNOME desktop environment";
    };
  };

  config = lib.mkIf cfg.enable {
    features.displayManagers = {
      gdm.enable = lib.mkDefault true;
      autoLogin.enable = lib.mkDefault true;
    };
    services = {
      desktopManager.gnome.enable = true;
      xserver.enable = true;
      # Disable power-profiles-daemon to avoid conflict with TLP
      power-profiles-daemon.enable = false;
    };
    systemd.services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
  };
}
