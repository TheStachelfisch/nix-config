{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ./hardware-configuration.nix

    ../common/global
    ../common/users/thestachelfisch

    ../common/optional/server
    ../common/optional/wireless.nix
    ../common/optional/bluetooth.nix
    ../common/optional/quietboot.nix

    ./services
  ];
  security.sudo.wheelNeedsPassword = false;

  # Disable fast roaming causing WiFi Disconnects
  boot.extraModprobeConfig = ''
    options brcmfmac roamoff=1 feature_disable=0x82000
    options cfg80211 ieee80211_regdom="DE"
  '';

  networking.networkmanager.wifi.backend = lib.mkForce "iwd";
  networking.networkmanager.wifi.powersave = lib.mkForce false;
  networking.wireless.iwd.enable = true;
  networking.wireless.iwd.settings = {
    DriverQuirks = {
      PowerSaveDisable = "*";
    };
  };
  hardware.firmware = with pkgs; [
    wireless-regdb
  ];

  # fkms-3d devicetrees are currently broken... again
  hardware.raspberry-pi."4" = {
    fkms-3d.enable = true;
  };

  boot.plymouth = {
    theme = "hexagon_dots";
    themePackages = with pkgs; [
      (adi1090x-plymouth-themes.override {
        selected_themes = [ "hexagon_dots" ];
      })
    ];
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "printy";

  system.stateVersion = "25.05";
}
