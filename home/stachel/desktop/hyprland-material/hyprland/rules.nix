{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      # No borders on unfocused windows, since they are set to full alpha anyway
      "noborder, focus:0 floating:1"
      # Dim around polkit screen
      "dimaround, title:(Authenticate)"
      # KeepassXC
      "center 1, title:(Unlock Database|Access Request)"
      "float, title:(Unlock Database|Access Request)"
      "stayfocused, class:^(pinentry-:)" # fix pinentry losing focus
    ];

    layerrule = [
      "blur,gtk-layer-shell"
      "blur,rofi"
      "ignorezero,gtk-layer-shell"

      "animation slide,eww-control-center"
      "blur,eww-window"
      "ignorealpha 0.6,eww-window"
      "xray 1,eww-window"

      "blur,rofi"
      "ignorealpha 0.6,rofi"
    ];
  };
}
