{ inputs, ... }:
{
  flake-file.inputs = {
    systems.url = "github:nix-systems/default-linux";

    flake-file.url = "github:vic/flake-file";
  };

  imports = [
    inputs.flake-file.flakeModules.dendritic
  ];

  systems = import inputs.systems;
}
