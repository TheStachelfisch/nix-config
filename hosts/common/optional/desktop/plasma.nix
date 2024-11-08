{pkgs, ...}: {
  imports = [
    ../sound.nix
    ../quietboot.nix
    ../printing.nix
  ];

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.enableHidpi = true;
  services.desktopManager.plasma6.enable = true;

  security.pam.services.kde.fprintAuth = false;
}
