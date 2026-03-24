{
  inputs,
  ...
}:
{
  flake.modules.nixos.system-server =
    {
      lib,
      ...
    }:
    {
      imports = with inputs.self.modules.nixos; [
        system-cli
      ];

      # Not required on servers. Removes ~300MiB
      nix.registry = lib.mkForce { };
      nix.settings.flake-registry = "";
      documentation.nixos.enable = false;
    };

  flake.modules.homeManager.system-server = {
    imports = with inputs.self.modules.homeManager; [
      system-cli
    ];
  };
}
