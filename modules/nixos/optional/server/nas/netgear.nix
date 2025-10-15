{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.server.nas.netgear;
in {
  options.features.server.nas.netgear = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable netgear nas";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts = {
      "netgear.${config.networking.hostName}" = {
        listen = [
              {
                addr = "0.0.0.0";
                port = 80;
              }
            ];
        locations."/" = {
          proxyPass = "http://192.168.87.165:80";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          rejectSSL = true;
          extraConfig = ''
proxy_http_version 1.1;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;

      # Sometimes needed if the NAS hardcodes https:// in redirects
      proxy_redirect https:// http://;
          '';
        };
      };
    };
    environment.systemPackages = with pkgs; [
      nfs-utils
      cifs-utils
    ];
    services.rpcbind.enable = true;

    fileSystems."/data" = {
      device = "192.168.87.165:/c/data";
      fsType = "nfs";
      options = ["vers=3"];
    };
  };
}
