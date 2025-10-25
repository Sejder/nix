{ config, pkgs, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos
    ];

  networking.hostName = "ideapad";

  systemUsers = {
    users = ["mikke"];
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

  environment.systemPackages = with pkgs; [ cacert ];
  environment.variables.SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  environment.variables.SSL_CERT_DIR  = "${pkgs.cacert}/etc/ssl/certs";
  services.rstudio-server.enable = true;


  system.stateVersion = "25.05";
}