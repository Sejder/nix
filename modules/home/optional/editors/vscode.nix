{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.features.editors.vscode;
in
{
  options.features.editors.vscode.enable = lib.mkEnableOption "Enable vscode as editor";

  config = lib.mkIf (cfg.enable && config.features.apps.enable) {
    home.packages = with pkgs; [
      vscode
      nil
    ];

    programs.vscode = {
      enable = true;

      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          formulahendry.code-runner
          jnoortheen.nix-ide
        ];
        userSettings = {
          files.autoSave = "afterDelay";
          editor = {
            formatOnSave = true;
            formatOnPaste = true;
            quickSuggestions = {
              other = true;
              comments = false;
              strings = false;
            };
            paramaterHints = {
              enable = true;
            };
            suggest = {
              loyaltyBonus = true;
            };
            autoIndentOnPaste = true;
            wordBasedSuggestions = "off";
          };
          "explorer.confirmDragAndDrop" = false;
          "workbench.secondarySideBar.defaultVisibility" = "hidden";
          "workbench.startupEditor" = "none";

          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";
        };

        keybindings = [
          {
            key = "ctrl+t";
            command = "workbench.action.terminal.toggleTerminal";
            when = "terminal.active";
          }

          {
            key = "f5";
            command = "code-runner.run";
            when = "editorFocus";
          }
          {
            key = "f6";
            command = "testing.runAll";
            when = "";
          }
        ];

        enableUpdateCheck = false;

        enableExtensionUpdateCheck = false;
      };
    };
  };
}
