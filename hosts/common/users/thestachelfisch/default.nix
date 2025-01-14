{
  pkgs,
  config,
  lib,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = false;
  users.users.thestachelfisch = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ifTheyExist [
      "wheel"
      "audio"
      "video"
      "network"
      "plugdev"
    ];

    openssh.authorizedKeys.keyFiles = [../../../../home/thestachelfisch/ssh.pub];
    hashedPasswordFile = config.sops.secrets.thestachelfisch-password.path;
  };

  programs.zsh.enable = true;

  sops.secrets.thestachelfisch-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };
}
