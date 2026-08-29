{ inputs, ... }:
{
  flake-file.inputs = {
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
}
