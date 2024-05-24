{ pkgs, inputs, outputs, config, ... }:
{
  imports =
    [
      inputs.nixos-hardware.nixosModules.framework-16-7040-amd

      ./hardware-configuration.nix
      ../../system/global
      ../../system/users/stachel

      ../../system/optional/laptop
      ../../system/optional/wireless.nix
      ../../system/optional/greetd.nix
      ../../system/optional/storagebox.nix

      ../../system/optional/desktop
      ../../system/optional/desktop/hyprland-material.nix
    ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  services.preload.enable = true;
  security.polkit.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [ "root" "@wheel" ];
  };

  hardware.keyboard.qmk.enable = true;

  networking.hostName = "framework"; # Define your hostname.

  services.fwupd.enable = true;

  console = {
    font = "Lat2-Terminus16";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ gutenprint ];

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    font-awesome
    nerdfonts
    jetbrains-mono
    google-fonts
  ];

  programs.zsh.enable = true;
  system.stateVersion = "24.05"; # Did you read the comment?
}
