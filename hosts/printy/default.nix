{ pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/users/thestachelfisch

    ../common/optional/server
    ../common/optional/wireless.nix
    ../common/optional/bluetooth.nix
    ../common/optional/quietboot.nix

    ./services
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  security.sudo.wheelNeedsPassword = false;

  # Disable fast roaming causing WiFi Disconnects
  # boot.extraModprobeConfig = ''
  #   options brcmfmac roamoff=1 feature_disable=0x82000
  # '';

  networking.networkmanager.wifi.backend = lib.mkForce "iwd";
  
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "printy";

  system.stateVersion = "25.05";
}
