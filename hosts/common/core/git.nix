{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName  = "Mikkelsej";
    userEmail = "mikkel.sejdelin@gmail.com";

    extraConfig = {

      init = {
        defaultBranch = "main";
      };

      core = {
        excludesFile = "/home/mikke/.config/git/ignore";
      };

    };
  };

  home.file.".config/git/ignore".text = ''
    .venv/
    .vscode/
    .idea/
    *.class
    .obsidian/
  '';
}