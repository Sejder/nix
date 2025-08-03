{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;

    virtualHosts = {
      "home" = {
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:5000";
          };
        };        
      };

      "cloud.home" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:80";
        };
      };

      "immich.home" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:2283";
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


  environment.systemPackages = with pkgs; [
    nginx
  ];
}
