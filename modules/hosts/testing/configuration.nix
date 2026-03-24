{
  inputs,
  lib,
  ...
}:
{
  flake.modules.nixos.testingServer =
    {
      pkgs,
      ...
    }:
    {
      imports = with inputs.self.modules.nixos; [
        system-server
      ];

      environment.systemPackages = with pkgs; [
        sl
      ];

      networking.hostName = "testingServer";
      networking.networkmanager.enable = true;
      services.openssh.settings.PermitRootLogin = lib.mkForce "yes";
    };
}
