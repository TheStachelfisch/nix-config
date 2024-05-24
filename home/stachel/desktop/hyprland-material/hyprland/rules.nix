{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      # No borders on unfocused windows, since they are set to full alpha anyway
      "noborder, focus:0 floating:1"
      "dimaround, title:(Authenticate)"
      "noanim, title:(rofi-launcher)"
    ];

    layerrule = [
      "blur,gtk-layer-shell"
      "blur,rofi"
      "ignorezero,gtk-layer-shell"
      "ignorezero,rofi"
      "dimaround,rofi"
      "animation slide,rofi"
    ];
  };
}
