{ config, lib, ... }:

{
  config = lib.mkIf config.features.server.monitoring.glances.enable {
    services.glances.enable = true;
    services.glances.port = 9091;
    services.nginx.virtualHosts."glances.${config.networking.hostName}".locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.glances.port}";
    };
  };
}
