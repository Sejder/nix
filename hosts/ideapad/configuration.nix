{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./../../modules/nixos
    ];

  networking.hostName = "ideapad";

  features = {
    settings.audio.enable = true;
    
    desktopenv.gnome.enable = true;

  };

  system.stateVersion = "24.11";

}
