{config, pkgs, lib, ... }:

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
    
    home.packages = with pkgs; [
      typst
    ];


    programs.vscode.profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        myriad-dreamin.tinymist
      ];

      userSettings = {
        tinymist.exportPdf = "onType";
      };
    };


  };
}