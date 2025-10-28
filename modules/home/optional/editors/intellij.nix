{ config, pkgs, lib, ... }:

let
  cfg = config.features.editors.intellij;
in
{
  options.features.editors.intellij.enable = 
    lib.mkEnableOption "Enable Intellij as editor";
  
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      jetbrains.idea-ultimate
      jetbrains-toolbox
    ];
  };
}