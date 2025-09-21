{ config, lib, pkgs, ... }:

with lib;

let
  obsidian-startup = pkgs.writeScriptBin "obsidian-startup" ''
    #!${pkgs.zsh}/bin/zsh
    set -e

    CONFIG="$HOME/.config/obsidian/obsidian.json"
    
    if [[ -f "$CONFIG" ]]; then
        sed -i.bak 's/,"open":true//g' "$CONFIG"
    fi

    obsidian &
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