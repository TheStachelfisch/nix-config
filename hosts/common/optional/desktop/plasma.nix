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

  programs.dconf.enable = true;

  services.colord.enable = true;
  environment.systemPackages = with pkgs; [kdePackages.colord-kde];
}
