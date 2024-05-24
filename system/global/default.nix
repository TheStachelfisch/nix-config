{ outputs, ... }:
{
  imports = [
    ./locale.nix
    ./openssh.nix
    ./sops.nix
    ./polkit.nix
  ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  hardware.enableRedistributableFirmware = true;
}
