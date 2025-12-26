{
  config,
  unstable-pkgs,
  lib,
  ...
}:
let
  cfg = config.features.documentWriters.typst;
in
{
  options.features.documentWriters.typst = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Typst";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with unstable-pkgs; [
      typst
    ];

    programs.zed-editor = {
      extensions = [
        "typst"
      ];
      userSettings = {
        lsp = {
          tinymist = {
            settings = {
              exportPdf = "onSave";
              outputPath = "$root/$name";
            };
          };
        };
      };
    };

    programs.vscode.profiles.default = {
      extensions = with unstable-pkgs.vscode-extensions; [
        myriad-dreamin.tinymist
      ];

      userSettings = {
        tinymist.exportPdf = "onType";
        tinymist.statusBarFormat = "{compileStatusIcon} {wordCount} {charCount} [{fileName}]";
        github.copilot.enable = {
          "typst" = false;
        };
      };
    };
  };
}
