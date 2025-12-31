{
  config,
  pkgs,
  deviceType ? "",
  ...
}:
{
  imports = [
    ../modules/home
  ];

  features = {
    editors = {
      vscode.enable = true;
      nvf.enable = true;
      jetbrains.enable = true;
      zed.enable = true;
    };

    chatbots = {
      github-copilot.enable = true;
      claude-code.enable = true;
      gemini.enable = true;
    };

    browsers.firefox.enable = true;
    desktopenv.cosmic.enable = deviceType != "server";
    desktopenv.hyprland.enable = deviceType == "server";
    apps.enable = deviceType == "laptop";
    programmingLanguages.enable = true;
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
      poppler-utils
      yarn
    ];
  };

  programs.home-manager = {
    enable = true;
  };
}
