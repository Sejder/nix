{config, pkgs, lib, ... }:

let
  cfg = config.features.latex;
in
{
  options.features.latex = {

    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable latex";
    };


  };

  config = lib.mkIf cfg.enable {
    
    home.packages = with pkgs; [
      vscode
      vscode-extensions.james-yu.latex-workshop
      texliveFull
    ];
  };
}