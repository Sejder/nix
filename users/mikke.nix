{ config, pkgs, ... }:

{
  imports = [
    ../modules/home
  ];

  features = {
    editors = {
      vscode.enable = true;
      nvf.enable = true;
      jetbrains.enable = true;
    };

    chatbots = {
      github-copilot.enable = true;
      claude-code.enable = true;
    };

    browsers.firefox.enable = true;
    desktopenv.cosmic.enable = true;
    apps.enable = true;
    programmingLanguages.enable = false;
    scripts = {
      ytdownloader.enable = true;
      cloudBackup = {
        enable = true;
        targetDir = "${config.home.homeDirectory}/cloudBackup";
      };
    };
  };

home = {
    username = "mikke";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "25.05";
    packages = with pkgs; [ 
      obs-studio
    ];
    
  };
  
  programs.home-manager = {
    enable = true;
  };

}
