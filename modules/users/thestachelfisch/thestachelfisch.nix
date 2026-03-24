{
  self,
  pkgs,
  lib,
  ...
}:
let
  username = "thestachelfisch";
in
{
  flake.modules = lib.mkMerge [
    (self.factory.user "${username}" true)
    {
      nixos."${username}" = {
        users.users.${username} = {
          password = "test";
        };
      };
      homeManager."${username}" = { };
    }
  ];
}
