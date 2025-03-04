{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/users/thestachelfisch

    ../common/optional/server
    ../common/optional/wireless.nix
    ../common/optional/bluetooth.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  security.sudo.wheelNeedsPassword = false;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "printy";

  # Listen on port 23 as there are multiple ssh hosts on the same ip
  services.openssh.ports = [ 22 ];

  system.stateVersion = "25.05";
}
