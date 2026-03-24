{
  self,
  lib,
  ...
}:
{
  config.flake.factory.user = username: isAdmin: {
    nixos."${username}" =
      { lib, pkgs, ... }:
      {
        users.users."${username}" = {
          isNormalUser = true;
          home = "/home/${username}";
          extraGroups = lib.optionals isAdmin [
            "wheel"
          ];
        };

        # home-manager.users."${username}" = {
        #   imports = [
        #     self.modules.homeManager."${username}"
        #   ];
        # };
      };

    homeManager."${username}" = {
      home.username = "${username}";
    };
  };
}
