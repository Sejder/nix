{ config, lib, ... }:

{
  config = lib.mkIf config.features.desktopenv.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      # Autostart
      exec-once = [
        "hyprpaper"
        "hyprlock"
        "systemctl --user start hyprpolkitagent"
        "hyprctl setcursor Bibata-Modern-Ice 24"
        "swayosd-server"
        "nextcloud"
        "waybar"
        "~/.config/nwg-dock-hyprland/launch.sh"
        "swaync"
      ];
    };
  };
}