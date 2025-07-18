{ config, pkgs, ... }:

{
  services.tailscale.enable = true;

  networking.firewall.allowedUDPPorts = [ 41641 ];
  networking.firewall.allowedTCPPorts = [ 80 8080 ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    hostName = "nextcloud";
    https = false;
    maxUploadSize = "2G";
    config = {
      adminuser = "admin";
      adminpassFile = "/etc/nextcloud-admin-pass";
      dbtype = "sqlite";
      #datadirectory = "/mnt/storage/nextcloud";
    };
  };

  environment.etc."nextcloud-admin-pass".text = "YOUR_SUPER_SECURE_PASSWORD";

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    tailscale
    nextcloud-client
  ];
}
