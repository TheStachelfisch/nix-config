{
  inputs,
  ...
}:
{
  flake.modules.nixos.system-default = {
    imports =
      with inputs.self.modules.nixos;
      [
        system-minimal

        home-manager
        secrets
      ]
      ++ (with inputs.self.modules.generic; [
        pkgs-by-name
      ]);

    users.mutableUsers = false;
  };

  flake.modules.homeManager.system-default = {
    imports = with inputs.self.modules.homeManager; [
      system-minimal
      secrets
    ];
  };
}
