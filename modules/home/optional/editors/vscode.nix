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
  };
}