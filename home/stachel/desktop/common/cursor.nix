{ pkgs, ... }:
{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "macOS-BigSur";
    size = 16;
    package = pkgs.apple-cursor;
  };
}
