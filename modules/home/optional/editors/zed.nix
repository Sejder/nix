{
  config,
  unstable-pkgs,
  lib,
  ...
}:
let
  cfg = config.features.editors.zed;
  langCfg = config.features.programmingLanguages;
in
{
  options.features.editors.zed.enable = lib.mkEnableOption "Enable zed as editor";

  config = lib.mkIf (cfg.enable && config.features.apps.enable) {
    home.packages = with unstable-pkgs; [
      zed-editor
    ];

    programs.zed-editor = {
      enable = true;
      extensions = [
        "git-firefly"
      ]
      ++ lib.optional langCfg.nix.enable "nix"
      ++ lib.optional langCfg.c-sharp.enable "C#"
      ++ lib.optional langCfg.R.enable "R"
      ++ lib.optional langCfg.java.enable "java"
      ++ lib.optional langCfg.python.enable "python"
      ++ lib.optional langCfg.rust.enable "rust"
      ++ lib.optional config.features.documentWriters.typst.enable "typst";
      package = unstable-pkgs.zed-editor;
      userSettings = {
        agent = {
          inline_assistant_model = {
            provider = "copilot_chat";
            model = "gpt-5-mini";
          };
          model_parameters = [];
        };
        git = {
          inline_blame = {
            enabled = false;
          };
        };
        show_edit_predictions = false;
        inlay_hints = {
          show_background = true;
          enabled = true;
        };
        toolbar = {
          code_actions = false;
        };
        minimap = {
          thumb = "always";
          show = "never";
        };
        autosave = {
          after_delay = {
            milliseconds = 1000;
          };
        };
        features = {
          edit_prediction_provider = "copilot";
        };
        theme = {
          mode = "system";
          light = "One Light";
          dark = "One Dark";
        };
        base_keymap = "JetBrains";
        lsp = lib.mkMerge [
          (lib.mkIf config.features.documentWriters.typst.enable {
            tinymist = {
              settings = {
                exportPdf = "onSave";
                outputPath = "$root/$name";
              };
            };
          })
          (lib.mkIf langCfg.nix.enable {
            nil = {
              settings = {
                nix = {
                  flake = {
                    autoArchive = true;
                  };
                };
              };
            };
          })
        ];
      };
    };
  };
}
