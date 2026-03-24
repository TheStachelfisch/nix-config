{
  flake.modules.nixos.firmware = {
    services.fwupd.enable = true;
    hardware = {
      enableRedistributableFirmware = true;
      enableAllFirmware = true;
    };
    nixpkgs.config.allowUnfree = true;
  };
}
