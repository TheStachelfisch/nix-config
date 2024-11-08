{
  lib,
  config,
  outputs,
  ...
}: let
  hosts = lib.attrNames outputs.nixosConfigurations;
in {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };

    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  programs.ssh = {
    startAgent = true;
    knownHosts = lib.genAttrs hosts (hostname: {
      publicKeyFile = ../../${hostname}/ssh_host_ed25519_key.pub;
      extraHostNames =
        [
          "${hostname}.thestachelfisch.dev"
        ]
        ++ (lib.optional (hostname == config.networking.hostName) "localhost");
    });
  };
}
