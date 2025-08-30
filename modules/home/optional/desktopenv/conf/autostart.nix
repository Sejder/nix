{ config, lib, ... }:

{
  config = lib.mkIf config.features.desktopenv.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      # Autostart
      exec-once = [
        "~/.config/nwg-dock-hyprland/launch.sh"
        "swaync"
        "hyprpaper"
        "systemctl --user start hyprpolkitagent"
        "hyprctl setcursor Bibata-Modern-Ice 24"
        "swayosd-server"
        "nextcloud"
        "waybar"
      ];
    };
  };
}