{
  inputs,
  lib,
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

        desktop-plasma
      ];

      networking.hostName = "nixos-desktop";
    };
}
