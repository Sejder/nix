{ config, lib, pkgs, ... }:

# Follows the format:
# monitor = name, resolution@framerate, position, scale

# Find monitors by using hyprctl monitors all

# Resolution can be highres
# Framerate can be highrr

# Availible positions are
# auto
# auto-down/up/left/right

{
  home.file.".config/hypr/conf/monitor.conf".text = ''
    # Monitor Configuration for Hyprland
    monitor=,preferred,auto,auto
  '';
}
