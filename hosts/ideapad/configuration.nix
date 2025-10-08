{ config, pkgs, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos
    ];

  networking.hostName = "ideapad";
  device = {
    type = "laptop";
    resolution = "2k";
  };

  features = {
    server.enable = false;
    nix-ld.enable = true;
    virtualisation.docker.enable = true;
  };

  system.stateVersion = "25.05";
}