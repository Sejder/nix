{ pkgs, lib, config, ... }:

lib.mkIf config.features.desktopenv.hyprland.waybar.enable {
  programs.waybar.settings = [{
        "layer" = "top";
        "position" = "top";
        "reload_style_on_change" = true;
        "modules-left" = [
            "hyprland/workspaces"
        ];

        "modules-right" = [
            "group/expand"
            "pulseaudio"
            "bluetooth"
            "network"
            "battery"
            "clock"
            "custom/notification"
            "custom/wlogout"
        ];
        "hyprland/workspaces" = {
            "format" = "{name}";
            "format-icons" = {
                "active" = "⬤";
                "default" = "○";
                "empty" = "◌";
            };
            "persistent-workspaces" = {
                "*" = [
                    1
                    2
                    3
                ];
            };
        };
        "custom/notification" = {
            "tooltip" = false;
            "format" = "󰂚";
            "on-click" = "swaync-client -t -sw";
            "escape" = true;
        };
        "clock" = {
            "format" = "{:%H:%M}";
            "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            "format-alt" = "{:%d-%m-%Y}";
        };
        "network" = {
            "format-wifi" = "";
            "format-ethernet" = "";
            "format-disconnected" = "󰖪";
            "tooltip-format-disconnected" = "No connection";
            "tooltip-format-wifi" = "{essid} ({signalStrength}%) ";
            "tooltip-format-ethernet" = "{ifname} ";
            "on-click" = "kitty --title 'Network Manager' -e nmtui";
        };
        "bluetooth" = {
            "format-on" = "󰂯";
            "format-off" = "󰂲";
            "format-disabled" = "󰂲";
            "format-connected-battery" = "{num_connections} 󰂯";
            "format-alt" = "󰂯";
            "tooltip-format" = "{controller_alias} ({device_enumerate}%)";
            "on-click" = "blueman-manager";
        };
        "pulseaudio" = {
            format = "{icon}";
            "format-muted" = "";
            "format-source-muted" = "";
            "format-icons" = {
                "default" = [
                    ""
                    ""
                    ""
                    ""
                ]; 
            };
            on-click = "pavucontrol";
        };
        "battery" = {
            "interval" = 30;
            "states" = {
                "good" = 95;
                "warning" = 30;
                "critical" = 10;
            };
            "format" = "{icon}";
            "format-charging" = " {capacity}% 󰂄 ";
            "format-plugged" = " {capacity}% 󰂄 ";
            "format-alt" = " {time} {icon}";
            "tooltip-format" = "{capacity}% Empty in {time}";
            "format-icons" = [
                "󰂎"  # 0–10%
                "󰁺"  # 11–20%
                "󰁻"  # 21–30%
                "󰁼"  # 31–40%
                "󰁽"  # 41–50%
                "󰁾"  # 51–60%
                "󰁿"  # 61–70%
                "󰂀"  # 71–80%
                "󰂁"  # 81–90%
                "󰁹"  # 91–100%
            ];
        };
        "custom/expand" = {
            "format" = "⏷";
            "tooltip" = false;
        };
        "custom/endpoint" = {
            "format" = "|";
            "tooltip" = false;
        };
        "custom/wlogout" = {
          "format" = ""; # power icon
          "tooltip" = "Logout / Power Menu";
          "on-click" = "wlogout"; # or "wlogout -b 5" for buttons at bottom
          "escape" = true;
        };
        "group/expand" = {
            "orientation" = "horizontal";
            "drawer" = {
                "transition-duration" = 600;
                "transition-to-left" = true;
                "click-to-reveal" = true;
            };
            "modules" = [
                "custom/expand"
                "cpu"
                "memory"
                "temperature"
                "tray"
                "custom/endpoint"
            ];
        };
        "cpu" = {
            "format" = "";
            "tooltip" = true;
        };
        "memory" = {
            "format" = "󰍛";
        };
        "temperature" = {
            "critical-threshold" = 80;
            "format" = "";
        };
        "tray" = {
            "icon-size" = 16;
            "spacing" = 12;
        };
      }];
}
