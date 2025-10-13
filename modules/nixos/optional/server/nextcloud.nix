{ config, pkgs, lib, ...}:

let 
  cfg = config.features.server.nextcloud;
in
{
  options.features.server.nextcloud = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable nextcloud";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."nextcloud-admin-pass".text = "PWD";

    services.nextcloud = {
      enable = true;
      configureRedis = true;
      hostName = "cloud.${config.networking.hostName}";
      package = pkgs.nextcloud32;

      config = {
        adminpassFile = "/etc/nextcloud-admin-pass";
        dbtype = "sqlite";
      };

      datadir = "/data/nextcloud";

      settings = {
        trusted_domains = [
          "localhost"
          "127.0.0.1"
          "cloud.${config.networking.hostName}"
        ];
        trusted_proxies = [ "127.0.0.1" ];
        enabledPreviewProviders = [
          "OC\\Preview\\BMP"
          "OC\\Preview\\GIF"
          "OC\\Preview\\JPEG"
          "OC\\Preview\\Krita"
          "OC\\Preview\\MarkDown"
          "OC\\Preview\\MP3"
          "OC\\Preview\\OpenDocument"
          "OC\\Preview\\PNG"
          "OC\\Preview\\TXT"
          "OC\\Preview\\XBitmap"
          "OC\\Preview\\HEIC"
          "OC\\Preview\\MP4"
          "OC\\Preview\\WEBM"
        ];
      };
    };

    services.nginx.virtualHosts."cloud.${config.networking.hostName}" = {
      listen = [{ addr = "0.0.0.0"; port = 80; }];
      locations."/" = {
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
  };
}