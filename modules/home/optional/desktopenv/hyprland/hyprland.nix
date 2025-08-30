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
