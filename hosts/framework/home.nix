{ ... }: {
  imports = [
    ../../home/stachel # Global Home Manager options
    ../../home/stachel/desktop/hyprland-material # Use Hyprland setup
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [ "eDP-1,2560x1600@165,0x0,1.6,vrr,1" ];
    xwayland = {
      force_zero_scaling = true;
    };
    env = [
      "GDK_SCALE,1.6"
      "STEAM_FORCE_DESKTOPUI_SCALING,1.6"
    ];
  };

  theme = {
    enable = true;
    wallpaper = ./wallpapers/blobs-d.svg;
    variant = "dark";
  };
}
