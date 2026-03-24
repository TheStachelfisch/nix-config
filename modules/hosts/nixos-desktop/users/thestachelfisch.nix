{
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.nixos-desktop =
    { config, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        thestachelfisch
      ];

      home-manager.users.thestachelfisch = {
        imports = with inputs.self.modules.homeManager; [
          system-desktop
        ];
      };
    };
}
