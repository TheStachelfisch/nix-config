{ pkgs, ... }:
{
  home.packages = with pkgs.gnome; [ weather ];
}
