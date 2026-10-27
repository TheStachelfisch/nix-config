{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos {
    system = "aarch64-linux";
    name = "gen-fra1-arm-srv-oci-03";
    channel = "stable";
  };
}
