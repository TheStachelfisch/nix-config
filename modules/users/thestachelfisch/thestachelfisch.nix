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
      nixos."${username}" = { config, ... }: {
        users.users.${username} = {
          hashedPasswordFile = config.sops.secrets."user-passwords.thestachelfisch".path;
        };

        sops.secrets."user-passwords.thestachelfisch" = {
          sopsFile = "${self.inputs.secrets}/user-secrets.ini";
          format = "ini";
          neededForUsers = true;
        };
      };
      homeManager."${username}" = {
        imports = with self.modules.homeManager; [
          system-cli
        ];
      };
    }
  ];
}
