{ config, pkgs, lib, ... }:
let
  tailscaleHostName = "${config.networking.hostName}.at-ling.ts.net";
  cloudHostName = "cloud.${tailscaleHostName}";
in
{
  environment.etc."nextcloud-admin-pass".text = "PWD";

  services.nginx.enable = true;
  
  #services.nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [ {
  #  addr = "127.0.0.1";
  #  port = 8080; # NOT an exposed port
  #} ];

  services.nextcloud = {
    enable = true;
    hostName = "localhost";
    package = pkgs.nextcloud31;

    config = {
      adminpassFile = "/etc/nextcloud-admin-pass";
      dbtype = "sqlite";
    };

    settings = 
    {
      overwriteprotocol = "http";
      overwrite.cli.url = cloudHostName;
      trusted_domains = [
        cloudHostName
        "localhost"
        "127.0.0.1"
      ];
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
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    nextcloud31
  ];



  
}