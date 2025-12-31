{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.features.displayManagers.lightdm;
in
{
  options.features.displayManagers.lightdm.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable LightDM";
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager = {
        lightdm = {
          enable = true;
          greeters.enso = {
            enable = true;
          };
          background = "/etc/sundown-over-sea.jpg";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      catppuccin-gtk
      papirus-icon-theme
      catppuccin-cursors
      jetbrains-mono
    ];
  };
}
