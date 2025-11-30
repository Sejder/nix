{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.features.desktopenv.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      # Variables
      "$SCRIPTS" = "~/.config/hypr/scripts/";
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$filemanager" = "nautilus";
      "$menu" = "rofi -show combi";
      "$browser" = "firefox";
      "$HOME" = config.home.homeDirectory;

      # Environment
      env = [
        "XCURSOR_THEME,Bibata-Modern-Ice"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      # Monitor Configuration
      # name,resolution,position,scale
      monitor = [
        "eDP-1,preferred,auto,auto"
        "DP-1,preferred,auto-left,auto"
        "DP-2,preferred,auto-center-up,auto"
      ];

      # General
      general = {
        gaps_in = 5;
        gaps_out = 0;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        mouse_move_enables_dpms = true;
        mouse_move_focuses_monitor = true;
      };

      input = {
        kb_layout = "dk";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.4;
        };
      };
    };
  };
}
