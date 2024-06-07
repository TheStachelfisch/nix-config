{ ... }: {
  imports = [
    ../../home/stachel # Global Home Manager options
    ../../home/stachel/desktop/hyprland-material # Use Hyprland setup
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [ "eDP-1,2560x1600@165,0x0,1.6,vrr,1" ];
  };

  theme = {
    enable = true;
    wallpaper = ./wallpapers/test.png;
    variant = "dark";
  };
}
