{ config, lib, pkgs, ... }:
let
  cfg = config.features.desktopenv.hyprland.scripts.screenshot;
in
{
  options.features.desktopenv.hyprland.scripts.screenshot = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.features.desktopenv.hyprland.enable;
      description = "Enable Screenshot script for hyprland";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file.".config/hypr/scripts/screenshot.sh" = {
      source = ./screenshot.sh;
      executable = true;
    };

    home.packages = with pkgs; [
      grim
      slurp
      grimblast
    ];
  };
}
