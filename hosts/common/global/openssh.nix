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
      Macs = [
        # Default
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"

        # Added
        "hmac-sha2-256"
      ];
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
          "${hostname}"
        ]
        ++ (lib.optional (hostname == config.networking.hostName) "localhost");
    });
  };
}
