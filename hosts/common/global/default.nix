{outputs, ...}: {
  imports = [
    ./nix.nix
    ./sops.nix
    ./locale.nix
    ./openssh.nix
    ./hardware.nix
    ./networking.nix
    ./tailscale.nix
  ];

  programs.nano.enable = false;
}
