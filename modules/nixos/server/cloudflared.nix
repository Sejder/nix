{ config, pkgs, ... }:

{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "0" = {
        credentialsFile = "/etc/cloudflared/0.json";
        default = "http_status:404";
        ingress = {
          "mikkelsej.site" = "http://1270.0.0.1:80";

          "*.mikkelsej.site" = "http://127.0.0.1:80";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    cloudflared
  ];
}