{ config, lib, ... }:

{
  config = lib.mkIf config.features.server.monitoring.glances.enable {
    services = {
      glances = {
        enable = true;
        port = 9091;
      };
      nginx.virtualHosts."glances.${config.networking.hostName}".locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.glances.port}";
      };
    };
  };
}
