_:
let
  home-manager-config =
    { lib, ... }:
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPkgs = true;
      };
    };
in
{
  flake.modules.nixos.home-manager = {
    imports = [
      home-manager-config
    ];
  };
}
