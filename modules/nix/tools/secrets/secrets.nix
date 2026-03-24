{
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.secrets =
    { pkgs, config, ... }:
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      sops =
        let
          isEd25519 = k: k.type == "ed25519";
          keys = map (k: k.path) builtins.filter isEd25519 config.services.openssh.hostKeys;
        in
        {
          defaultSopsFile = "${self.inputs.secrets}/user-secrets.ini";
          age = {
            sshKeyPaths = keys;
            keyFile = "/var/lib/sops-nix/key.txt";
            generateKey = true;
          };
        };
    };

  flake.modules.homeManager.secerts = {
    imports = [
      inputs.sops-nix.homeManagerModules.sops
    ];
  };
}
