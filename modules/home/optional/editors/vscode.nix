{ config, pkgs, lib, ... }:

let
  cfg = config.features.editors.vscode;
in
{
  options.features.editors.vscode.enable = 
    lib.mkEnableOption "Enable vscode as editor";
  
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      vscode
    ];
    
    programs.vscode = {
      enable = true;
      
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          formulahendry.code-runner
        ];

        userSettings = {
          files.autoSave = "afterDelay";
          editor = {
            formatOnSave = true;
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
          };
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