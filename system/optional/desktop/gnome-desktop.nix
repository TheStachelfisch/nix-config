{ pkgs, ... }: 
{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  services.gnome.core-utilities.enable = false;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    orca
  ];

  # Core utilities for the Gnome desktop that don't particularly fit into the common apps for all desktop environments
  environment.systemPackages = with pkgs.gnome; [
    pkgs.snapshot
  ];
}
