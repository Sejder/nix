{ config, pkgs, ... }:

{
  imports = [
    ./../modules/home
  ];

  features = {
    editors.vscode.enable = true;

    browsers.firefox.enable = true;

  };


  home = {
    username = "mikke";

    homeDirectory = "/home/${config.home.username}";

    stateVersion = "25.05";
  }

  programs.home-manager.enable = true;
}