{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos
    ];

  networking.hostName = "ideapad";

  device = "laptop";

  features = {
    nix-ld.enable = true;
  };

  system.stateVersion = "25.05";

}
