{ ... }:
{
  imports = [
    ../sound.nix
    ../printing.nix
    ../quietboot.nix
  ];

  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  programs.dconf.enable = true;
}
