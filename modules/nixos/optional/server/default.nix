{ config, lib, ... }:

let
  cfg = config.features.server;
in
{
  options.features.server = {
    enable = lib.mkEnableOption "Enable this host as a server";
  };
  
  config = lib.mkIf cfg.enable {
    features = {
      server = {
        nginx.enable = true;
        nextcloud.enable = true;
        monitoring.enable = true;
      };
      settings = {
        audio.enable = false;
      };
    };

    boot.loader.timeout = 5;
    services.xserver.enable = false;
    services.xserver.desktopManager.enable = false;
    services.xserver.displayManager.enable = false;
    services.getty.autologin = {
      enable = true;
      user = "mikke";
    };
  };
}