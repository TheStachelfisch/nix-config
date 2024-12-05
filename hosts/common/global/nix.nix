{inputs, outputs, lib, ...}: let
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in  {
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = ["root" "@wheel"];
      warn-dirty = false;
      auto-optimise-store = lib.mkDefault true;
      flake-registry = "";
    };

    channel.enable = false;

    # Add each flake input as a registry and nix_path
    # courtesy of https://github.com/Misterio77/nix-config/blob/8bb813869ea740fd7bcca1a033ecb53cc2bf77de/hosts/common/global/nix.nix#L40
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };
}
