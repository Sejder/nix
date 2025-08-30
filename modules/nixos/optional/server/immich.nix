{ config, lib, ... }:

let
  cfg = config.options.server.immich;
in
{
  options.features.server.immich = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable immich";
    };
  };
  
  config = lib.mkIf cfg.enable {
    services.immich = {
      enable = true;
      port = 2283;
      host = "127.0.0.1";
    };

    services.nginx.virtualHosts = {
      "immich.${config.networking.hostName}" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.immich.port}";
            proxyWebsockets = true;
            recommendedProxySettings = true;
            extraConfig = ''
              client_max_body_size 100G;           
              proxy_read_timeout 600s;
              proxy_send_timeout 600s;
            '';
        };
      };
    };
  };
}