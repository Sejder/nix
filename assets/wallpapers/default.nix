{ config, lib, ... }:
let
  users = config.systemUsers.users or ["mikke"];
  anyUserHasWallpaper = lib.any (user:
    config.home-manager.users.${user}.features.desktopenv.hyprland.wallpaper.enable or false
  ) users;
in
{
  config = lib.mkIf anyUserHasWallpaper {
    environment.etc."wallpapers/sundown-over-sea.jpg".source = ./sundown-over-sea.jpg;
  };
}