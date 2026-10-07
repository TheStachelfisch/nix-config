{
  inputs,
  ...
}:
{
  flake.modules.nixos.gen-fra1-arm-srv-oci-03 =
    { ... }:
    {
      imports = with inputs.self.modules.nixos; [
        thestachelfisch
      ];

      home-manager.users.thestachelfisch = {
        imports = with inputs.self.modules.homeManager; [
          thestachelfisch
        ];
      };
    };
}
