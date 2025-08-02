{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;

    virtualHosts."home" = {
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:5000";
        };        
      };
    };

  };

  services.nginx.virtualHosts = {
    "cloud.home" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
      };
    };
  };

  services.nginx.virtualHosts = {
    "immich.home" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:2283";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    nginx
  ];
}
