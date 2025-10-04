{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos
    ];

  networking.hostName = "home";

  device = {
    type = "server";
    resolution = "1080p";
  };

  features = {
    nix-ld.enable = true;
    server.enable = true;
  };

  system.stateVersion = "25.05";

}
