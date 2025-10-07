{config, pkgs, lib, ... }:

let
  cfg = config.features.applicationLaunchers.rofi;
in
{
  options.features.applicationLaunchers.rofi = {
    enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Rofi";
    };
  };

  config = lib.mkIf cfg.enable {
      programs.rofi = {
        enable = true;
        package = pkgs.rofi;  
        theme = "nix/assets/rofiThemes/nord/nord.rasi";  

        # Extra Rofi settings
        extraConfig = {
          modi = "combi";
          combi-modes = "drun,recursivebrowser";
          show-icons = true;
          sidebar-mode = true;
          font = "JetBrainsMono Nerd Font 12";
          lines = 10;
          columns = 1;
          location = 0;  # Centered
          width = 50;
          padding = 10;
          fixed-num-lines = true;
          hide-scrollbar = true;
          bw = 0;
        };
      };
  };
}