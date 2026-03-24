{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "path:./secrets";
      flake = false;
    };
  };
}
