{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos
    ];

  networking.hostName = "home";

  device = "laptop";

  features = {
    nix-ld.enable = true;
    server.enable = true;
  };

  system.stateVersion = "25.05";

}
