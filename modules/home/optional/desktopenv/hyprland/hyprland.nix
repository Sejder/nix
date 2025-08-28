{ config, pkgs, lib, ... }:
let
  cfg = config.features.desktopenv.hyprland;
in
{
  options.features.desktopenv.hyprland = {
    enable = lib.mkEnableOption "Hyprland";

    waybar.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable waybar";
    };

    hypridle.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable Hypridle";
    };

    hyprlock.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable Hyprlock";
    };

    kitty.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable Kitty";
    };

    wallpaper.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable wallpaper";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        settings = {
          # Variables
          "$SCRIPTS" = "~/.config/hypr/scripts/";
          "$mainMod" = "SUPER";
          "$terminal" = "kitty";
          "$filemanager" = "nautilus";
          "$menu" = "rofi -show drun";
          "$browser" = "firefox";
          "$HOME" = "~/home/mikke";

          # Environment
          env = [
            "XCURSOR_THEME,Bibata-Modern-Ice"
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"
          ];

          # Monitor Configuration
          monitor = [
            ",preferred,auto,auto"
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
            disable_hyprland_logo = false;
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
            };
          };

          # Animations
          animations = {
            enabled = true;
            bezier = [
              "wind, 0.05, 0.9, 0.1, 1.05"
              "winIn, 0.1, 1.1, 0.1, 1.1"
              "winOut, 0.3, -0.3, 0, 1"
              "liner, 1, 1, 1, 1"
            ];
            animation = [
              "windows, 1, 6, wind, slide"
              "windowsIn, 1, 6, winIn, slide"
              "windowsOut, 1, 5, winOut, slide"
              "windowsMove, 1, 3, wind, slide"
              "border, 1, 1, liner"
              "borderangle, 1, 15, liner, once"
              "fade, 1, 6, default"
              "workspaces, 1, 3, wind"
            ];
          };

          # Decorations
          decoration = {
            rounding = 10;
            active_opacity = 1.0;
            inactive_opacity = 0.8;
            fullscreen_opacity = 1.0;
            blur = {
              enabled = true;
              size = 6;
              passes = 2;
              new_optimizations = true;
              ignore_opacity = true;
              xray = true;
            };
            shadow = {
              enabled = true;
              range = 30;
              render_power = 3;
              color = "0x66000000";
            };
          };

          # Keybindings
          bind = [
            # Applications
            "$mainMod, RETURN, exec, $terminal"
            "$mainMod, B, exec, $browser"
            "$mainMod, F, exec, $filemanager"
            "$mainMod, space, exec, rofi -show combi"
            "$mainMod, C, exec, code"
            "$mainMod, O, exec, obsidian"
            "$mainMod, S, exec, spotify"
            "$mainMod, D, exec, discord"
            "$mainMod, I, exec, idea-community"

            # Windows
            "$mainMod, Q, killactive"
            "$mainMod SHIFT, Q, exec, hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill"
            "$mainMod, E, fullscreen, 0"
            "$mainMod, M, fullscreen, 1"
            "$mainMod, T, togglefloating"
            "$mainMod SHIFT, T, workspaceopt, allfloat"
            "$mainMod, J, togglesplit"
            "$mainMod, left, movefocus, l"
            "$mainMod, right, movefocus, r"
            "$mainMod, up, movefocus, u"
            "$mainMod, down, movefocus, d"
            "$mainMod SHIFT, right, resizeactive, 100 0"
            "$mainMod SHIFT, left, resizeactive, -100 0"
            "$mainMod SHIFT, down, resizeactive, 0 100"
            "$mainMod SHIFT, up, resizeactive, 0 -100"
            "$mainMod, G, togglegroup"
            "$mainMod, K, swapsplit"

            # Actions
            "$mainMod CTRL, R, exec, hyprctl reload"
            "$mainMod, PRINT, exec, $SCRIPTS/screenshot.sh"
            "$mainMod SHIFT, S, exec, $SCRIPTS/screenshot.sh"
            "$mainMod CTRL, W, exec, waypaper --folder ~/nix/wallpapers"
            "$mainMod CTRL, RETURN, exec, pkill rofi || rofi -show drun -replace -i"

            # Workspaces
            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"

            "$mainMod SHIFT, 1, movetoworkspace, 1"
            "$mainMod SHIFT, 2, movetoworkspace, 2"
            "$mainMod SHIFT, 3, movetoworkspace, 3"
            "$mainMod SHIFT, 4, movetoworkspace, 4"
            "$mainMod SHIFT, 5, movetoworkspace, 5"
            "$mainMod SHIFT, 6, movetoworkspace, 6"
            "$mainMod SHIFT, 7, movetoworkspace, 7"
            "$mainMod SHIFT, 8, movetoworkspace, 8"
            "$mainMod SHIFT, 9, movetoworkspace, 9"
            "$mainMod SHIFT, 0, movetoworkspace, 10"

            "$mainMod, Tab, workspace, m+1"
            "$mainMod SHIFT, Tab, workspace, m-1"
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
            "$mainMod CTRL, down, workspace, empty"

            # Fn keys
            ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
            ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
            ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
            ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
            ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioPause, exec, playerctl pause"
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPrev, exec, playerctl previous"
            ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
            ", XF86Lock, exec, notify-send h"
            ", CAPS_LOCK, exec, bash -c 'sleep 0.1 && swayosd-client --caps-lock'"
            ", NUM_LOCK, exec, bash -c 'sleep 0.1 && swayosd-client --num-lock'"
          ];

          # Mouse bindings
          bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];

          # Window rules
          windowrulev2 = [
            "float, title:^(Network Manager)$"
            "center, title:^(Network Manager)$"
            "movecursor, title:^(Network Manager)$"
            "stayfocused, title:^(Network Manager)$"

            "float, title:^(Volume Control)$"
            "center, title:^(Volume Control)$"
            "movecursor, title:^(Volume Controls)$"
            "stayfocused, title:^(Volume Control)$"

            "float, title:^(Bluetooth Devices)$"
            "center, title:^(Bluetooth Devices)$"
            "movecursor, title:^(Bluetooth Devices)$"
            #"stayfocused, title:^(Bluetooth Devices)$"
          ];

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

      services.swayosd = {
          enable = true;
      };

      home.packages = with pkgs; [
        bibata-cursors
        hyprpolkitagent
      ];

      features.applicationLaunchers.rofi.enable = true;
    })

    (lib.mkIf cfg.wallpaper.enable {
      services.hyprpaper = {
        enable = true;
        settings = {
          preload = [
            "/home/mikke/nix/assets/wallpapers/sundown-over-sea.jpg"
          ];
          wallpaper = [
            ",/home/mikke/nix/assets/wallpapers/sundown-over-sea.jpg"
          ];
          splash = false;
        };
      };
    })
  ];
  
}
