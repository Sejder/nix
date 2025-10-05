{config, pkgs, lib, ... }:

let
  cfg = config.features.documentWriters.latex;
in
{
  options.features.documentWriters.latex = {

    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable latex";
    };


  };

  config = lib.mkIf cfg.enable {
    
    home.packages = with pkgs; [
      texliveFull
    ];

    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
      james-yu.latex-workshop
    ];
  };
}