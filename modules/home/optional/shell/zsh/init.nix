{ config, pkgs, lib, ... }:

let
  cfg = config.features.shell.zsh;
in
{
  config = lib.mkIf cfg.enable {
    programs.zsh.initContent = ''
      # Check if we are on tty1, then start Hyprland
        if [[ "$(tty)" == "/dev/tty1" ]]; then
          exec Hyprland
        fi
        
        if [ -f /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh ]; then
          source /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh
        elif [ -f $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then
          source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
        fi

        # Check if terminal is a pseudo-terminal (pts)
        #if [[ $(tty) == *"pts"* ]]; then
          # Run fastfetch with the specified config
        #  fastfetch --config examples/13
        #fi
        export ZSH="${pkgs.zsh}/bin/zsh"
        export ZSH_HIGHLIGHT_STYLES='bg=blue'
        export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'
      '';
  };

}