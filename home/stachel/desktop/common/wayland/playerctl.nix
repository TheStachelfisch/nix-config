{ pkgs, ... }:
{
  services.playerctld.enable = true;
  home.packages = with pkgs; [
    playerctl
  ];
}
