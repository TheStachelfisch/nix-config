{ inputs, ... }:
{
  flake.modules.nixos.old-desktop =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ]
      ++ (with inputs.self.modules.nixos; [
        bluetooth
      ]);

      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [
        (pkgs.local.hid-module-corsair-void-patched.override {
          kernel = config.boot.kernelPackages.kernel;
        })
      ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.efi.efiSysMountPoint = "/boot/efi";

      boot.kernelPackages = pkgs.unstable.linuxPackages_latest;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

      fileSystems."/mnt/hdd" = {
        device = "/dev/disk/by-uuid/4caeb561-df88-403b-9810-a7acb412645b";
        fsType = "ext4";
        options = [
          "commit=30"
          "noatime"
          "x-gvfs-show"
          "nofail"
          "noauto"
          "x-systemd.automount"
        ];
      };

      boot.zswap = {
        enable = true;
      };

      boot.kernel.sysctl = {
        "vm.swappiness" = 180;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
      };

      services.keyd.keyboards = {
        corsair = {
          ids = [ "1b1c:1b49:857532cb" ];
          settings = {
            main = {
              esc = "overload(capslock, esc)";
              capslock = "esc";
              leftalt = "layer(nav)";
            };
            "nav:A" = {
              h = "left";
              k = "up";
              j = "down";
              l = "right";
            };
          };
        };
      };
    };
}
