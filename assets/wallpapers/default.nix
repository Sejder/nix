{ config, lib, ... }:
{
  config = lib.mkIf config.home-manager.users.mikke.features.desktopenv.hyprland.wallpaper.enable {
    environment.etc."wallpapers/sundown-over-sea.jpg".source = ./sundown-over-sea.jpg;
  };
}