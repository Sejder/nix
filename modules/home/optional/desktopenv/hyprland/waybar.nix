{ config, pkgs, lib, ... }:

let
  cfg = config.features.desktopenv.hyprland.waybar;
in
{
  config = lib.mkIf cfg.enable {

    programs.waybar = {
      enable = true;
      settings = [{
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
            "format" = " 󰂚 ";
            "on-click" = "swaync-client -t -sw";
            "escape" = true;
        };
        "clock" = {
            "format" = " {:%H:%M} ";
            "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            "format-alt" = " {:%d-%m-%Y} ";
        };
        "network" = {
            "format-wifi" = "   ";
            "format-ethernet" = "   ";
            "format-disconnected" = " 󰖪  ";
            "tooltip-format-disconnected" = "No connection";
            "tooltip-format-wifi" = " {essid} ({signalStrength}%)   ";
            "tooltip-format-ethernet" = "{ifname}   ";
            "on-click" = "kitty --title 'Network Manager' -e nmtui";
        };
        "bluetooth" = {
            "format-on" = " 󰂯 ";
            "format-off" = " 󰂲 ";
            "format-disabled" = " 󰂲 ";
            "format-connected-battery" = " {num_connections} 󰂯 ";
            "format-alt" = " 󰂯 ";
            "tooltip-format" = "{controller_alias} ({device_enumerate}%) ";
            "on-click" = "blueman-manager";
        };
        "pulseaudio" = {
            format = " {volume}%   ";
            "format-muted" = "   ";
            "format-source-muted" = "   ";
            on-click = "pavucontrol";
        };
        "battery" = {
            "interval" = 30;
            "states" = {
                "good" = 95;
                "warning" = 30;
                "critical" = 10;
            };
            "format" = " {capacity}% {icon} ";
            "format-charging" = " {capacity}% 󰂄 ";
            "format-plugged" = " {capacity}% 󰂄 ";
            "format-alt" = " {time} {icon}";
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
            "format" = " ⏷ ";
            "tooltip" = false;
        };
        "custom/endpoint" = {
            "format" = " | ";
            "tooltip" = false;
        };
        "custom/wlogout" = {
          "format" = "  "; # power icon
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
            "format" = "   ";
            "tooltip" = true;
        };
        "memory" = {
            "format" = " 󰍛 ";
        };
        "temperature" = {
            "critical-threshold" = 80;
            "format" = "  ";
        };
        "tray" = {
            "icon-size" = 16;
            "spacing" = 12;
        };
      }];


      style = ''
        * {
          font-size: 16px;
          font-family: "JetBrainsMono Nerd Font", "monospace";
          padding: 0;
          margin: 0;
        }

        button {
          box-shadow: inset 0 -3px transparent;
          border: none;
          border-radius: 0;
          padding: 0 10px;
        }

        button:hover {
          background: inherit;
          box-shadow: inset 0 -3px #ffffff;
        }

        window#waybar {
          all: unset;
        }

        .modules-left,
        .modules-right {
          padding: 0;
          margin: 0;
          border-radius: 10px;
          background: alpha(#0A0B0F, .0);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .0);
        }

        tooltip {
          background: #0A0B0F;
          color: #e1cdbf;
        }

        /* Default module styling */
        #clock,
        #custom-notification,
        #bluetooth,
        #network,
        #battery,
        #cpu,
        #pulseaudio,
        #memory,
        #tray,
        #temperature {
          color: white;
          background: alpha(#0A0B0F, .6);
          border-radius: 10px;
          margin: 2px;
          padding: 0 5px;
          min-width: 10px;
        }

        #custom-notification:hover,
        #bluetooth:hover,
        #network:hover,
        #battery:hover,
        #cpu:hover,
        #pulseaudio:hover,
        #memory:hover,
        #clock:hover,
        #temperature:hover {
          color: #1E90FF;
        }

        #battery.charging {
          color: #26A65B;
        }

        #battery.warning:not(.charging) {
          color: #ffbe61;
        }

        #battery.critical:not(.charging) {
          color: #f53c3c;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        @keyframes blink {
          to {
            background-color: #ffffff;
            color: #000000;
          }
        }

        #cpu,
        #memory,
        #temperature {
          color: rgba(255, 255, 255, 0.6);
          transition: all .3s ease;
        }

        #tray {
          padding: 0 10px;
          color: rgba(255, 255, 255, 0.6);
          transition: all .3s ease;
        }

        #tray menu * {
          padding: 0;
          transition: all .3s ease;
        }

        #tray menu separator {
          padding: 0;
          transition: all .3s ease;
        }

        #workspaces {
          padding: 0 5px;
          background: alpha(#0A0B0F, .6);
          border-radius: 10px;
          margin: 5px;
        }

        #workspaces button {
          opacity: 0.6;
          all: unset;
          padding: 5px 10px;
        }

        #workspaces button:hover {
          text-shadow: 0px 0px 1.5px rgba(0, 0, 0, .5);
          transition: all 1s ease;
        }

        #workspaces button.active {
          opacity: 1;
          text-shadow: 0px 0px 2px rgba(0, 0, 0, .5);
          background: alpha(#1E90FF, 0.3);
          border-radius: 10px;
        }

        #workspaces button.empty {
          text-shadow: 0px 0px 1.5px rgba(0, 0, 0, .2);
        }

        #workspaces button.empty:hover {
          text-shadow: 0px 0px 1.5px rgba(0, 0, 0, .5);
          transition: all 1s ease;
        }

        #workspaces button.empty.active {
          text-shadow: 0px 0px 2px rgba(0, 0, 0, .5);
        }
        #custom-wlogout {
          color: #ffffff;
          background: alpha(#0A0B0F, .6);
          border-radius: 10px;
          margin: 2px;
          padding: 0 8px;
        }
        #custom-wlogout:hover {
          color: #ffffff;
        }

      '';
    };

    home.packages = with pkgs; [
      wlogout
      pavucontrol
    ];
  };
}


