{ inputs, ... }:
{
  flake.modules.nixos.nixos-desktop =
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
        fan2go
      ]);

      boot.initrd.availableKernelModules = [
        "xhci_pci_prom21"
        "ahci"
        "nvme"
        "xhci_pci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [
        "kvm-amd"
        "nct6775"
        "ntsync"
      ];
      boot.extraModulePackages = [ ];

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        package = pkgs.unstable.mesa;
        package32 = pkgs.unstable.pkgsi686Linux.mesa;
      };

      hardware.amdgpu = {
        initrd.enable = true;
        overdrive.enable = true;
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

      environment.etc."fan2go/fan2go.yaml".text = /* yaml */ ''
        fans:
          - id: aio_pump
            hwmon:
              platform: "nct6799.*"
              rpmChannel: 1
              pwmChannel: 1
            neverStop: true
            curve: aio_pump_curve
          - id: bottom_case_fan
            hwmon:
              platform: "arctic_fan.*"
              rpmChannel: 1
              pwmChannel: 1
            neverStop: false
            curve: gpu_balanced_curve
          - id: rear_case_fan
            hwmon:
              platform: "arctic_fan.*"
              rpmChannel: 7
              pwmChannel: 7
            neverStop: false
            curve: slim_fan_curve
          - id: aio_fan
            hwmon:
              platform: "arctic_fan.*"
              rpmChannel: 8
              pwmChannel: 8
            neverStop: false
            curve: cpu_balanced_curve
          - id: vrm_fan
            hwmon:
              platform: "arctic_fan.*"
              rpmChannel: 9
              pwmChannel: 9
            neverStop: false
            curve: vrm_fan_curve
          - id: top_case_fan
            hwmon:
              platform: "arctic_fan.*"
              rpmChannel: 10
              pwmChannel: 10
            neverStop: false
            curve: cpu_balanced_curve
          # - id: gpu_fan
          # hwmon:
          #   platform: "amdgpu.*"
          #   rpmchannel: 1
          #   pwmchannel: 1
          # neverstop: false
          # curve: gpu_balanced_curve
        sensors:
          - id: cpu_temp
            hwmon:
              platform: "k10temp.*"
              index: 1
          - id: gpu_temp
            hwmon:
              platform: "amdgpu.*"
              index: 2
        curves:
          - id: aio_pump_curve
            staircase:
              sensor: cpu_temp
              hysteresis:
                down: 5
              steps:
                - 0: 35%
                - 75: 60%
                - 85: 90%
          - id: vrm_fan_curve
            staircase:
              sensor: cpu_temp
              hysteresis:
                down: 5
              steps:
                - 0: 0%
                - 71: 30%
                - 85: 50%
          - id: cpu_balanced_curve
            staircase:
              sensor: cpu_temp
              hysteresis:
                down: 6
              steps:
                - 0: 13%
                - 68: 25%
                - 78: 45%
                - 85: 85%
          - id: slim_fan_curve
            staircase:
              sensor: cpu_temp
              hysteresis:
                down: 6
              steps:
                - 0: 25%
                - 68: 40%
                - 78: 55%
                - 85: 90%
          - id: gpu_balanced_curve
            staircase:
              sensor: gpu_temp
              hysteresis:
                down: 5
              steps:
                - 0: 0%
                - 55: 12%
                - 68: 28%
                - 78: 45%
                - 85: 85%
      '';
    };
}
