{
  inputs,
  ...
}:
{
  flake.modules.nixos.framework-laptop =
    {
      pkgs,
      ...
    }:
    {
      imports = with inputs.self.modules.nixos; [
        system-desktop

        personal-storagebox

        desktop-plasma
      ];

      networking.hostName = "framework-16";
    };
}
