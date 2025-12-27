{config, pkgs, lib, deviceType, ... }:

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

  config = lib.mkIf (cfg.enable && deviceType == "laptop") {
    
    home.packages = with pkgs; [
      texliveFull
    ];

    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
      james-yu.latex-workshop
    ];
  };
}