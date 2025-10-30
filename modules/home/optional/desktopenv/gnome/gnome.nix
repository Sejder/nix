{ config, pkgs, lib, ... }:
let
  cfg = config.features.desktopenv.gnome;
in
{
  imports = [
    ./keybinds.nix
  ];

  options.features.desktopenv.gnome = {
    enable = lib.mkEnableOption "GNOME Desktop Environment";
  };

  config = lib.mkIf cfg.enable {
    # GNOME-specific packages for the user
    home.packages = with pkgs; [
      gnome-tweaks
      gnomeExtensions.appindicator
    ];
    home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ"; 
    # Enable common apps that work well with GNOME
    features = {
      terminalEmulators.kitty.enable = lib.mkDefault true;
      desktopApps.calculator.enable = lib.mkDefault true;
    };

    # GTK theme configuration
    gtk = {
      enable = true;
      gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
      };
    };
  };
}
