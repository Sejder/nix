{ config, pkgs, lib, ... }:

let
  cfg = config.features.desktopenv.gnome;
in
{
  options.features.desktopenv.gnome.enable = 
    lib.mkEnableOption "Enable gnome as desktop environment";
  
  config = lib.mkIf cfg.enable {
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;
    services.xserver.enable = true;
  };
}