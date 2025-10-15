{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.server;
in {
  options.features.server = {
    enable = lib.mkEnableOption "Enable this host as a server";
  };

  config = lib.mkIf cfg.enable {
    features = {
      server = {
        nginx.enable = true;
        nextcloud.enable = true;
        monitoring.enable = true;
        ssh.enable = true;
        nas.netgear.enable = true;
      };
      settings = {
        audio.enable = false;
        boot.autoBoot.enable = true;
      };

    };

    home-manager.users.mikke.features.scripts.cloudBackup.enable = true;

    services.getty = {
      autologinOnce = true;
      autologinUser = "mikke";
    };

  };
}
