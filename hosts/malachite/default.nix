{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/users/thestachelfisch
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # TODO: Move to server module. Needed for remote deployment
  security.sudo.wheelNeedsPassword = false;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "malachite";
  users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJdUvnMkxyVdtLnHmKfcZwRYay6kqAWXEjXr2GtAANNI''];
  system.stateVersion = "23.11";
}
