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
      nixos."${username}" =
        { config, ... }:
        {
          users.users.${username} = {
            hashedPasswordFile = config.sops.secrets."user_passwords/thestachelfisch".path;
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF11N4SUplaakwU3LWzf1IcGIunXaP97vK1UXVLX3skt"
            ];
            extraGroups = [ "plugdev" ];
          };

          imports = with self.modules.nixos; [
            nushell
          ];

          sops.secrets."user_passwords/thestachelfisch" = {
            neededForUsers = true;
          };
        };
      homeManager."${username}" = {
        imports = with self.modules.homeManager; [
          system-cli
          nushell
        ];
      };
    }
  ];
}
