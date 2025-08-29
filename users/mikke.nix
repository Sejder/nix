{ config, pkgs, ... }:

{
  imports = [
    ../modules/home
  ];

  nixpkgs.config.allowUnfree = true;

  features = {
    editors = {
      vscode.enable = true;
      
      
      neovim.enable = false;
      nvf.enable = true;
    };

    browsers.firefox.enable = true;

    desktopenv.hyprland.enable = true;

    apps.enable = true;

    programmingLanguages.enable = true;
  };


  home = {
    username = "mikke";

    homeDirectory = "/home/${config.home.username}";

    stateVersion = "25.05";

    packages = with pkgs; [
      
    ];
  };

  programs.home-manager.enable = true;
}
