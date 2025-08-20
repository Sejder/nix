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
    #desktopenv.hyprland.enable = true;
  };


  system.stateVersion = "25.05";

}
