{ ... }:
{
  flake.modules.nixos.gen-fra1-arm-srv-oci-03 =
    {
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

      boot.loader.efi.efiSysMountPoint = "/boot/efi";
      boot.loader.grub = {
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev";
      };

      boot.initrd.kernelModules = [ "nvme" ];
      boot.initrd.availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "xen_blkfront"
      ];

      fileSystems."/boot/efi" = {
        device = "/dev/disk/by-uuid/6E0A-88ED";
        fsType = "vfat";
      };
      fileSystems."/" = {
        device = "/dev/sda1";
        fsType = "ext4";
      };

      zramSwap = {
        enable = true;
        memoryPercent = 20;
      };

      nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
    };
}
