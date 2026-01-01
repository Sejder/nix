{
  config,
  lib,
  ...
}:
let
  cfg = config.features.desktopenv.plasma;
in
{
  config = lib.mkIf cfg.enable {
    programs.plasma = {
      fonts.general = {
        family = "JetBrains Mono";
        pointSize = 12;
      };

      shortcuts = {
        kwin = {
          "Manage Activities" = "none";
          "powerProfile" = "Battery";

          "Window Close" = "Meta+Q";
        };
      };

      hotkeys.commands = {
        "launch-kitty" = {
          name = "Launch Kitty";
          key = "Meta+Return";
          command = "konsole";
        };
        "launch-vscode" = {
          name = "Launch VS Code";
          key = "Meta+C";
          command = "code";
        };
        "launch-intellij" = {
          name = "Launch IntelliJ";
          key = "Meta+I";
          command = "idea-ultimate";
        };
        "launch-obsidian" = {
          name = "Launch Obsidian";
          key = "Meta+O";
          command = "obsidian-startup";
        };
        "launch-file-manager" = {
          name = "Launch File Manager";
          key = "Meta+E";
          command = "dolphin";
        };
        "launch-browser" = {
          name = "Launch Browser";
          key = "Meta+B";
          command = "firefox";
        };
      };
    };

  };
}
