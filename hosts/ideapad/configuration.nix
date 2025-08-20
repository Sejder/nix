{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos
    ];

  networking.hostName = "ideapad";

  features = {
    locale.dk = true;

    settings.audio.enable = true;
    
    desktopenv.hyprland.enable = true;
  };


  system.stateVersion = "25.05";

}
