let
  workspaces = builtins.concatLists (builtins.genList
    (
      x:
      let
        ws =
          let
            c = (x + 1) / 10;
          in
          builtins.toString (x + 1 - (c * 10));
      in
      [
        "$mod, ${ws}, workspace, ${toString (x + 1)}"
        "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
      ]
    )
    10);
in
{
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    bind =
      let
        terminal = "foot";
        appLauncher = "rofi -show drun -theme launcher -matching fuzzy";
      in
      [
        # Basic compositor bindings
        "$mod, SPACE, togglefloating"
        "$mod, C, killactive"
        "$mod, F, fullscreen"

        # Window-related binds
        "$mod, n, movefocus, l"
        "$mod, e, movefocus, d"
        "$mod, i, movefocus, u"
        "$mod, o, movefocus, r"
        "$mod_SHIFT, n, movewindow, l"
        "$mod_SHIFT, e, movewindow, d"
        "$mod_SHIFT, i, movewindow, u"
        "$mod_SHIFT, o, movewindow, r"

        # Workspace-related binds
        "$mod, A, workspace, -1"
        "$mod, T, workspace, +1"
        "$mod_SHIFT, A, movetoworkspace, -1"
        "$mod_SHIFT, T, movetoworkspace, +1"

        # Apps and programs
        "$mod, G, exec, ${terminal}"
        "$mod, M, exec, ${appLauncher}"
      ] ++ workspaces;

    # Mouse movements to resize windows and move them
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod ALT, mouse:272, resizewindow"
    ];

    bindl = [
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
    ];

    bindle = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_SINK@ 5%-"
    ];
  };
}
