{ config, lib, ... }:

{
  config = lib.mkIf config.features.desktopenv.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
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
    };
  };
}
