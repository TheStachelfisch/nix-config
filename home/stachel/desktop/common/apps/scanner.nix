{ pkgs, ... }:
{
  home.packages = with pkgs.gnome; [ simple-scan ];
}
