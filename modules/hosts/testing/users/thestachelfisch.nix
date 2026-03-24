{
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.testingServer =
    { config, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        thestachelfisch
      ];
    };
}
