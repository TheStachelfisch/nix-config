{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos {
    system = "x86_64-linux";
    name = "framework-laptop";
    channel = "unstable";
  };
}
