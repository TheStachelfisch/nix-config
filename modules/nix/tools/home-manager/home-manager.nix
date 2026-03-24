{
  inputs,
  ...
}:
let
  home-manager-config =
    { lib, ... }:
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };
in
{
  flake.modules.nixos.home-manager = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      home-manager-config
    ];
  };
}
