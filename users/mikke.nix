{ config, pkgs, ... }:

let
  isNixOS = config ? nixpkgs;
in {
  imports = [
    ../modules/home
  ];

  nixpkgs.config.allowUnfree = !isNixOS;

  features = {
    editors = {
      vscode.enable = isNixOS;
      neovim.enable = false;
      nvf.enable = true;
    };

    browsers.firefox.enable = isNixOS;
    desktopenv.hyprland.enable = isNixOS;
    apps.enable = isNixOS;
    programmingLanguages.enable = true;
  };

  home = {
    username = "mikke";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "25.05";

    packages = with pkgs; [ ];
  };

  programs.home-manager.enable = true;
}
