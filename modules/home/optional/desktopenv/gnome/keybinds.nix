{
  pkgs,
  ...
}:
{
  dconf.settings = {
    # Window manager keybindings
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
      maximize = [ "<Super>Up" ];
      minimize = [ "<Super>Down" ];
      switch-applications = [ "<Alt>Tab" ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
    };

    # Media keys for built-in shortcuts
    "org/gnome/settings-daemon/plugins/media-keys" = {
      home = [ "<Super>e" ];
      www = [ "<Super>b" ];
      rotate-video-lock-static = [ ]; # Disable to free up <Super>o for Obsidian
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
      ];
    };

    # Custom keybinding: Terminal
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Open Terminal";
      command = "${pkgs.kitty}/bin/kitty";
      binding = "<Super>Return";
    };

    # Custom keybinding: VS Code
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Open VS Code";
      command = "${pkgs.vscode}/bin/code";
      binding = "<Super>c";
    };

    # Custom keybinding: IntelliJ
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "Open IntelliJ";
      command = "${pkgs.jetbrains.idea}/bin/idea-ultimate";
      binding = "<Super>i";
    };

    # Custom keybinding: Obsidian
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      name = "Open Obsidian";
      command = "${pkgs.writeShellScript "obsidian-startup" ''
        CONFIG="$HOME/.config/obsidian/obsidian.json"
        if [[ -f "$CONFIG" ]]; then
            ${pkgs.gnused}/bin/sed -i 's/,"open":true//g' "$CONFIG"
        fi
        ${pkgs.obsidian}/bin/obsidian
      ''}";
      binding = "<Super>o";
    };
  };
}
