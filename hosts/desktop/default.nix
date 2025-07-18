{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    # Hardware imports
    ./hardware-configuration.nix

    # Global imports
    ../common/global
    ../common/users/thestachelfisch

    # Optional imports
    ../common/optional/wireless.nix
    ../common/optional/storagebox.nix
    # ../common/optional/full-system-virtualization.nix

    ../common/optional/desktop
    ../common/optional/desktop/gnome.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # TODO: Move to dedicated option for gaming peripherals
  hardware.xone.enable = true;

  programs.nix-ld.enable = true;

  networking.hostName = "desktop";
  services.fwupd.enable = true;
  services.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    keepassxc
    nur.repos.ataraxiasjel.waydroid-script
    wineWowPackages.waylandFull

    pkgs.inputs.colmena.colmena
    # inputs.colmena.packages.x86_64-linux.colmena

    moonlight-qt
  ];
  virtualisation.waydroid.enable = true;

  services.flatpak.enable = true;

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

  system.stateVersion = "24.05";
}
