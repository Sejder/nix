{ config, pkgs, lib, ... }:

let
  cfg = config.features.displayManagers.sddm;
in
{
  options.features.displayManagers.sddm.enable =
    lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable SDDM";
    };

  config = lib.mkIf cfg.enable {
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        theme = "catppuccin-mocha";
        package = pkgs.kdePackages.sddm;
      };
    };
    
    environment.systemPackages = [(
      pkgs.catppuccin-sddm.override {
        flavor = "mocha";
        font  = "Jetbrains Mono";
        fontSize = "18";
        #background = "${../../../../assets/wallpapers/sundown-over-sea.jpg}";
        #loginBackground = true;
      }
    )];
  };
}