{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  networking.hostName = "ideapad";

  systemUsers = {
    users = [ "mikke" ];
    primaryUser = "mikke";
  };

  device = {
    type = "laptop";
    resolution = "2k";
  };

  features = {
    server.enable = false;
    nix-ld.enable = true;
    virtualisation.docker.enable = true;
  };

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  environment.systemPackages = with pkgs; [ cacert ];
  environment.variables.SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  environment.variables.SSL_CERT_DIR = "${pkgs.cacert}/etc/ssl/certs";
  services.rstudio-server.enable = true;

  virtualisation.vmware.host = {
    enable = true;
    package = pkgs.vmware-workstation;
  };

  system.stateVersion = "25.05";
}
