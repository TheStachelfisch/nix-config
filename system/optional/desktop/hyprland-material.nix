{ inputs, pkgs, ... }:
{
  imports = [
    ../greetd.nix
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
}
