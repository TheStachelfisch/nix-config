{
  inputs,
  ...
}:
{
  flake.modules.nixos.old-desktop =
    {
      pkgs,
      ...
    }:
    {
      imports = with inputs.self.modules.nixos; [
        system-desktop

        steam
        openrgb
        personal-storagebox
        podman

        desktop-plasma
      ];

      networking.firewall.allowedTCPPorts = [ 25565 ];
      networking.firewall.allowedUDPPorts = [ 25565 ];

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
          libva-vdpau-driver
          libvdpau-va-gl
        ];
      };
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        branch = "legacy_580";
        open = false;
        powerManagement.enable = true;
      };
      environment.sessionVariables = {
        NVIDIA_shader_cache_skip_cleanup = "1";
        NVIDIA_shader_cache_size = "10737418240"; # 10 GB

        # Legacy
        __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
        __GL_SHADER_DISK_CACHE_SIZE = "10737418240";

        LIBVA_DRIVER_NAME = "nvidia";
        MOZ_DISABLE_RDD_SANDBOX = "1";
      };

      services.fwupd.enable = true;

      services.udev.extraRules = ''
        # TOPPING Audio USB & WebHID / WebUSB Permissions
        SUBSYSTEM=="usb", ATTR{idVendor}=="152a", MODE="0666", GROUP="users"
        SUBSYSTEM=="rawusb", ATTRS{idVendor}=="152a", MODE="0666", GROUP="users"
        KERNEL=="hidraw*", ATTRS{idVendor}=="152a", MODE="0666", GROUP="users"
      '';

      networking.hostName = "nixos-desktop";
    };
}
