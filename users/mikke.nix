{ config, pkgs, ... }:

{
  features = {
    editors.vscode.enable = true;

    desktopenv.gnome.enable = true;

    browsers.firefox.enable = true;

    displaymanagers.sddm.enable = true;
  };
}