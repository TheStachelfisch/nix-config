{
  inputs,
  ...
}:
{
  flake.modules.generic.pkgs-by-name =
    { ... }:
    {
      nixpkgs.overlays = [
        inputs.self.overlays.default
      ];
    };
}
