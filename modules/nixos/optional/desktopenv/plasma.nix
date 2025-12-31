{
  config,
  lib,
  ...
}:

let
  cfg = config.features.desktopenv.plasma;
in
{
  options.features.desktopenv.plasma = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default =
        let
          users = config.systemUsers.users or [ "mikke" ];
          anyUserHasPlasma = lib.any (
            user: config.home-manager.users.${user}.features.desktopenv.plasma.enable or false
          ) users;
        in
        anyUserHasPlasma;
      description = "Enable KDE Plasma desktop environment";
    };
  };

  config = lib.mkIf cfg.enable {
    features.displayManagers.sddm.enable = lib.mkDefault true;
    services.desktopManager.plasma6.enable = true;

    security.pam.services.sddm.kwallet = {
      enable = true;
    };

    # Disable power-profiles-daemon to avoid conflict with TLP
    services.power-profiles-daemon.enable = false;

    # Enable KDE Partition Manager if needed
    programs.kdeconnect.enable = lib.mkDefault true;
  };
}
