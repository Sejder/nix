{
  pkgs,
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
    apps.mathematica.enable = true;
  };

  hardware = {
    graphics.enable = true;
    nvidia.open = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  environment = {
    systemPackages = with pkgs; [
      cacert
      sublime4
    ];
    variables = {
      SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      SSL_CERT_DIR = "${pkgs.cacert}/etc/ssl/certs";
    };
  };
  services.rstudio-server.enable = true;

  virtualisation.vmware.host = {
    enable = true;
    package = pkgs.vmware-workstation;
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  system.stateVersion = "25.05";
}
