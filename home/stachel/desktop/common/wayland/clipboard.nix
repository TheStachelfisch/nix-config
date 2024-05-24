{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
  ];
  services.cliphist = {
    enable = true;
    systemdTarget = "graphical-session.target";
  };
}
