{ config, pkgs, lib, ... }:

let
  cfg = config.features.desktopenv.hyprland.waybar;
in
{
  config = lib.mkIf cfg.enable {

    programs.waybar = {
      enable = true;
            
    };

    home.packages = with pkgs; [
      wlogout
      pavucontrol
      jetbrains-mono
    ];
  };
}
