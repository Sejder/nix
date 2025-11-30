{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.features.desktopenv.hyprland.enable {
    wayland.windowManager.hyprland = {
      settings = {
        # Keybindings
        bind = [
          # Applications
          "$mainMod, T, exec, $terminal"
          "$mainMod, B, exec, $browser"
          "$mainMod, F, exec, $filemanager"
          "$mainMod, space, exec, rofi -show combi"
          "$mainMod, C, exec, code"
          "$mainMod, O, exec, obsidian-startup"
          "$mainMod, S, exec, spotify"
          "$mainMod, D, exec, discord"
          "$mainMod, N, exec, kitty nvim"

          # Windows
          "$mainMod, Q, killactive"
          "$mainMod SHIFT, Q, exec, hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill"
          "$mainMod, E, fullscreen, 0"
          "$mainMod, M, fullscreen, 1"
          #"$mainMod, T, togglefloating"
          "$mainMod SHIFT, T, workspaceopt, allfloat"
          "$mainMod, J, togglesplit"
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod SHIFT, right, resizeactive, 100 0"
          "$mainMod SHIFT, left, resizeactive, -100 0"
          "$mainMod SHIFT, down, resizeactive, 0 100"
          "$mainMod SHIFT, up, resizeactive, 0 -100"
          "$mainMod, G, togglegroup"
          "$mainMod, K, swapsplit"

          # Actions
          "$mainMod CTRL, R, exec, hyprctl reload"
          "$mainMod, PRINT, exec, $SCRIPTS/screenshot.sh"
          "$mainMod SHIFT, S, exec, $SCRIPTS/screenshot.sh"
          "$mainMod CTRL, W, exec, waypaper --folder ~/nix/wallpapers"
          "$mainMod CTRL, RETURN, exec, pkill rofi || rofi -show drun -replace -i"

          "$mainMod, L, exec, hyprlock"

          # Workspaces
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          "$mainMod, Tab, workspace, m+1"
          "$mainMod SHIFT, Tab, workspace, m-1"
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
          "$mainMod CTRL, down, workspace, empty"

          # Fn keys
          ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
          ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
          ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
          ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
          ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPause, exec, playerctl pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
          ", XF86Lock, exec, notify-send h"
          ", CAPS_LOCK, exec, bash -c 'sleep 0.1 && swayosd-client --caps-lock'"
          ", NUM_LOCK, exec, bash -c 'sleep 0.1 && swayosd-client --num-lock'"

          ", switch:on:Lid Switch, exec, hyprctl dispatch dpms off"
          ", switch:off:Lid Switch, exec, hyprctl dispatch dpms on"
        ];

        # Mouse bindings
        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
      };
    };
  };
}

