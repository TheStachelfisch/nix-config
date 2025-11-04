{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../common/global
    ../../common/users/thestachelfisch
    ../../common/optional/server
    ../../common/optional/server/mass-storage.nix

    ./services
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # TODO: Move to server module. Needed for remote deployment
  security.sudo.wheelNeedsPassword = false;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "gen-fra1-arm-srv-oci-02";

  system.stateVersion = "23.11";
}
