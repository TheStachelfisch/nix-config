{ inputs, ... }:
{
  flake-file.inputs = {
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  imports = [ inputs.home-manager.flakeModules.home-manager ];
}
