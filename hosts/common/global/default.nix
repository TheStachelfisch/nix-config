{outputs, ...}: {
  imports = [
    ./nix.nix
    ./sops.nix
    ./locale.nix
    ./openssh.nix
    ./hardware.nix
    ./networking.nix
  ];
}
