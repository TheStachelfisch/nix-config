{ pkgs, config, lib, ... }:
{
  users.mutableUsers = false;
  users.users.stachel = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "audio"
      "video"
    ];

    openssh.authorizedKeys.keyFiles = [ ../../../home/stachel/ssh.pub ];
    hashedPasswordFile = config.sops.secrets.stachel-password.path;
  };

  sops.secrets.stachel-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };
}
