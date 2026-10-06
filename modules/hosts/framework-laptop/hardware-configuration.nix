{ inputs, ... }:
{
  flake.modules.nixos.framework-laptop =
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

      boot.initrd.includeDefaultModules = false;
      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "xhci_pci_prom21"
        "nvme"

        "usbhid"
        "hid_generic"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [
        "kvm-amd"
        "ntsync"
      ];
      boot.extraModulePackages = [ ];
      boot.kernelParams = [
        "split_lock_mitigate=0"
      ];
      boot.kernel.sysctl = {
        "vm.max_map_count" = 2147483642;
      };

      security.tpm2.enable = true;
      environment.systemPackages = [
        pkgs.systemd-cryptenroll
        pkgs.tpm2-tools
      ];

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        package = pkgs.unstable.mesa;
        package32 = pkgs.unstable.pkgsi686Linux.mesa;
      };

      hardware.amdgpu = {
        initrd.enable = true;
      };

      environment.sessionVariables = {
        MESA_SHADER_CACHE_MAX_SIZE = "12G";
      };

      services.fwupd.enable = true;

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.efi.efiSysMountPoint = "/boot/efi";

      boot.kernelPackages = pkgs.unstable.linuxPackages_latest;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

      boot.zswap = {
        enable = true;
      };

      boot.kernel.sysctl = {
        "vm.swappiness" = 100;
      };
    };
}
