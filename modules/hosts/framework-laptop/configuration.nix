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

      # Disable fprintd for plasma login to prevent long timeout
      security.pam.services.plasmalogin.fprintAuth = false;

      networking.hostName = "framework-16";
    };
}
