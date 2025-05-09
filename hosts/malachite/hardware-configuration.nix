{
  modulesPath,
  lib,
  ...
}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/A552-E981";
    fsType = "vfat";
  };
  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront"];
  boot.initrd.kernelModules = ["nvme"];
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
