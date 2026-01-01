{ config, lib, ... }:

{
  config = lib.mkIf config.features.server.monitoring.cockpit.enable {
    services.cockpit = {
      enable = true;
      allowed-origins = [
        "http://cockpit.${config.networking.hostName}"
      ];
      settings = {
        WebService = {
          AllowUnencrypted = true;
        };
      };
    };

    services.nginx.virtualHosts."cockpit.${config.networking.hostName}".locations."/" = {
      proxyPass = "http://127.0.0.1:9090";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };
}
