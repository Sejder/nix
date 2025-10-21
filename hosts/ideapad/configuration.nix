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

  services.rstudio-server.enable = true;

  features = {
    server.enable = false;
    nix-ld.enable = true;
    virtualisation.docker.enable = true;
  };



  system.stateVersion = "25.05";
}