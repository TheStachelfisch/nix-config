{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../common/global
    ../../common/users/thestachelfisch
    ../../common/optional/server
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # TODO: Move to server module. Needed for remote deployment
  security.sudo.wheelNeedsPassword = false;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "gen-fra1-arm-srv-oci-03";

  system.stateVersion = "23.11";
}
