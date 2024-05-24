{ ... }: {
  imports = [
    ../../home/stachel # Global Home Manager options
    ../../home/stachel/desktop/hyprland-material # Use Hyprland setup
  ];

  theme = {
    enable = true;
    wallpaper = ./wallpapers/new2.jpg;
    variant = "dark";
  };
}
