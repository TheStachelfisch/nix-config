{
  flake.modules.nixos.testingServer =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # Use latest kernel.
      boot.kernelPackages = pkgs.linuxPackages_latest;

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ohci_pci"
        "ehci_pci"
        "virtio_pci"
        "ahci"
        "usbhid"
        "sr_mod"
        "virtio_blk"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/660d669e-358f-41af-bdbc-abbe11e43c8b";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/FF43-D64B";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [ ];

      services.qemuGuest.enable = true;
      services.spice-vdagentd.enable = true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    };
}
