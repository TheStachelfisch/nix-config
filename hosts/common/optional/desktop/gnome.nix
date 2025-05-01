{ pkgs, config, ... }:
{
  imports = [
    ../sound.nix
    ../printing.nix
    ../quietboot.nix
  ];

  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-software
    gnome-connections
    gnome-terminal
    gnome-console
    gnome-system-monitor

    epiphany # Gnome web
    geary # Mail viewer
    totem # Standard video player
    yelp  # Help software
    evince # Standard document viewer
  ];

  services.udev.packages = [ pkgs.gnome-settings-daemon ];
  programs.dconf.enable = true;

  services.gnome.gnome-keyring.enable = true;
  # If the desktop is unlocked using fprintd, then the login process hangs for a bit as the keyring can't be unlocked initially using the fingerprint
  security.pam.services.gdm.enableGnomeKeyring = !config.services.fprintd.enable;
}
