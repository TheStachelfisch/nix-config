{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    # Hardware imports
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    ./hardware-configuration.nix

    # Global imports
    ../common/global
    ../common/users/thestachelfisch

    # Optional imports
    ../common/optional/laptop
    ../common/optional/wireless.nix
    ../common/optional/storagebox.nix
    ../common/optional/full-system-virtualization.nix

    # ../common/optional/desktop/plasma.nix
    ../common/optional/desktop/gnome.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # TODO: Move to dedicated option for gaming peripherals
  hardware.xone.enable = true;

  hardware.framework.enableKmod = true;

  programs.nix-ld.enable = true;

  networking.hostName = "framework";
  services.fwupd.enable = true;
  services.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    keepassxc
    nur.repos.ataraxiasjel.waydroid-script
    inputs.colmena
    wineWowPackages.waylandFull
  ];
  virtualisation.waydroid.enable = true;

  services.xserver.xkb.extraLayouts."EurKEY-Colemak" = {
    symbolsFile = ./EurKeyXKB;
    languages = ["eng" "ger"];
    description = "EurKEY Colemak layout";
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraPackages = with pkgs; [
      mangohud
    ];
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    extest.enable = true;
    gamescopeSession = {
      enable = true;
    };
  };

  # Windows 10 virsual machine shared folder
  services.spice-webdavd.enable = true;

  system.stateVersion = "24.05";
}
