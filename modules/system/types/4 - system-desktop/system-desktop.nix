{
  inputs,
  ...
}:
{
  flake.modules.nixos.system-desktop =
    {
      lib,
      ...
    }:
    {
      imports = with inputs.self.modules.nixos; [
        system-cli

        colemak-keyboard
        ssh
        xdg
        pipewire
        networkmanager
      ];

      time.timeZone = "Europe/Berlin";
    };

  flake.modules.homeManager.system-desktop = {
    imports = with inputs.self.modules.homeManager; [
      system-cli

      xdg
    ];
  };
}
