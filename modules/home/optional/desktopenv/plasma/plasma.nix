{
  config,
  lib,
  ...
}:
let
  cfg = config.features.desktopenv.plasma;
in
{

  options.features.desktopenv.plasma = {
    enable = lib.mkEnableOption "KDE Plasma Desktop Environment";
  };

  config = lib.mkIf cfg.enable {
    # Plasma-specific packages for the user
    programs.plasma.enable = true;

    # Qt theme configuration
    qt = {
      enable = true;
      platformTheme.name = "kde";
      style.name = "breeze";
    };

    # GTK theme configuration for GTK apps in Plasma
    gtk = {
      enable = true;
      gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };
}
