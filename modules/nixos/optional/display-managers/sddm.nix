{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.features.displayManagers.sddm;
in
{
  options.features.displayManagers.sddm.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable SDDM";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        theme = "catppuccin-macchiato-teal";
      };
    };

    environment.systemPackages = [
      (pkgs.catppuccin-sddm.override {
        flavor = "macchiato";
        accent = "teal";
        font = "JetBrains Mono";
        fontSize = "18";
        loginBackground = true;
      })
    ];
  };
}
