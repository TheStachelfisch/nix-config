{
  flake.modules.nixos.auto-upgrade = {
    system.autoUpgrade = {
      enable = true;
      flake = "github:thestachelfisch/nix-config/dendritic-config";
      runGarbageCollection = true;
    };

    nix.optimise = {
      automatic = true;
    };
  };
}
