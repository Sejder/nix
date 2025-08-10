{ config, pkgs, ... }:

{
  imports = [
    ./../modules/home
  ];

  features = {
    editors.vscode.enable = true;

    browsers.firefox.enable = true;

  };


  home.username = "mikke";
  home.homeDirectory = "/home/mikke";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}