{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.features.desktopenv.cosmic;
in
{
  options.features.desktopenv.cosmic = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default =
        let
          users = config.systemUsers.users or [ "mikke" ];
          anyUserHascosmic = lib.any (
            user: config.home-manager.users.${user}.features.desktopenv.cosmic.enable or false
          ) users;
        in
        anyUserHascosmic;
      description = "Enable cosmic desktop environment";
    };
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.cosmic-greeter.enable = true;

    services.desktopManager.cosmic.enable = true;
    services.desktopManager.cosmic.xwayland.enable = true;
    services.power-profiles-daemon.enable = false;
    services.system76-scheduler.enable = true;
    hardware.system76.enableAll = true;
  };
}
