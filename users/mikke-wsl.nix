{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../modules/home
  ];

  features = {
    editors.nvf.enable = true;

    chatbots = {
      github-copilot.enable = true;
      claude-code.enable = true;
      gemini.enable = true;
    };

    programmingLanguages.enable = true;
    scripts = {
      ytdownloader.enable = true;
    };
  };

  home = {
    username = "mikke";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "25.05";
    packages = with pkgs; [
    ];
  };

  programs.home-manager = {
    enable = true;
  };
}
