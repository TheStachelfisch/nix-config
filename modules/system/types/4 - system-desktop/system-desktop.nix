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
        ssh
      ];
    };

  flake.modules.homeManager.system-desktop = {
    imports = with inputs.self.modules.homeManager; [
      system-cli
    ];
  };
}
