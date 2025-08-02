{ config, pkgs, lib, ... }:

{
  environment.etc."nextcloud-admin-pass".text = "PWD";

  

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
      trusted_domains = [
        "localhost"
        "127.0.0.1"
        "nixos"
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