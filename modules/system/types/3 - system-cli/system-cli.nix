{
  inputs,
  ...
}:
{
  flake.modules.nixos.system-cli = {
    boot = {
      tmp = {
        useTmpfs = true;
        cleanOnBoot = true;
      };
    };

    imports = with inputs.self.modules.nixos; [
      system-default

      firewall
      firmware
      openssh
      console
      i18n-locale
      tailscale
    ];
  };

  flake.modules.homeManager.system-cli = {
    imports = with inputs.self.modules.homeManager; [
      system-default
    ];
  };
}
