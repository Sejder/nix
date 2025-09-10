{
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf config.features.desktopenv.hyprland.waybar.enable {
  programs.waybar.style = ''
        * {
          font-size: 14px;
          font-family: "JetBrainsMono Nerd Font", "monospace";
        }

        button {
          box-shadow: inset 0 -3px transparent;
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
          color: white;
          background: alpha(#0A0B0F, .6);
          border-radius: 10px;
          margin: 5px;
          padding: 0px;
        }

        tooltip {
          background: #0A0B0F;
          color: #e1cdbf;
        }

        /* Default module styling */
        #clock,
        #custom-notification,
        #custom-wlogout,
        #bluetooth,
        #network,
        #battery,
        #cpu,
        #pulseaudio,
        #memory,
        #tray,
        #temperature {
          background: none;
          padding: 0px 10px;
          min-width: 10px;
        }

        #custom-notification:hover,
        #custom-wlogout:hover,
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
          background: none;
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

      '';
}
