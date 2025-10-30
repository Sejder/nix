{ config, lib, pkgs, ... }:

with lib;

let
  obsidian-startup = pkgs.writeScriptBin "obsidian-startup" ''
    #!${pkgs.bash}/bin/bash

    CONFIG="$HOME/.config/obsidian/obsidian.json"

    if [[ -f "$CONFIG" ]]; then
        ${pkgs.gnused}/bin/sed -i 's/,"open":true//g' "$CONFIG"
    fi

    ${pkgs.obsidian}/bin/obsidian
  '';
in
{
  options.features.scripts.obsidian-startup = {
    enable = mkEnableOption "Enable Obsidian startup";
  };

  config = mkIf config.features.scripts.obsidian-startup.enable {
    home.packages = with pkgs; [
      obsidian
      obsidian-startup
    ];
  };
}