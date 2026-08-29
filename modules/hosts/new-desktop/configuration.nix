{
  inputs,
  ...
}:
{
  flake.modules.nixos.nixos-desktop =
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

        desktop-plasma
      ];

      networking.firewall.allowedTCPPorts = [ 25565 ];
      networking.firewall.allowedUDPPorts = [ 25565 ];

      services.udev.extraRules = ''
        # TOPPING Audio USB & WebHID / WebUSB Permissions
        SUBSYSTEM=="usb", ATTR{idVendor}=="152a", MODE="0666", GROUP="users"
        SUBSYSTEM=="rawusb", ATTRS{idVendor}=="152a", MODE="0666", GROUP="users"
        KERNEL=="hidraw*", ATTRS{idVendor}=="152a", MODE="0666", GROUP="users"
      '';

      networking.hostName = "nixos-desktop";
    };
}
