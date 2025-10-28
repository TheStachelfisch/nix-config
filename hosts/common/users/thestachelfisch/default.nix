{
  pkgs,
  config,
  lib,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  environment.shells = [pkgs.nushell];
  users.mutableUsers = false;
  users.users.thestachelfisch = {
    isNormalUser = true;
    shell = pkgs.nushell;
    extraGroups = ifTheyExist [
      "wheel"
      "audio"
      "video"
      "network"
      "libvirtd"
      "kvm"
      "gamemode"
      "podman"
      "dialout"
    ] ++ [ "plugdev" ];

    openssh.authorizedKeys.keyFiles = [../../../../home/thestachelfisch/ssh.pub];
    hashedPasswordFile = config.sops.secrets.thestachelfisch-password.path;
  };

  sops.secrets.thestachelfisch-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };
}
