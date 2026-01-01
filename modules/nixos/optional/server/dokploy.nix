{
  config,
  lib,
  ...
}: let
  cfg = config.features.server.dokploy;
in {
  options.features.server.dokploy = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Dokploy";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts = {
      "dokploy.${config.networking.hostName}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
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
