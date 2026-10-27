{
  flake.modules.nixos.auto-upgrade = {
    system.autoUpgrade = {
      enable = false; # TODO: Evaluate usage for servers
      flake = "github:thestachelfisch/nix-config/dendritic-config";
      runGarbageCollection = true;
    };

    nix = {
      optimise = {
        automatic = true;
        dates = "weekly";
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
    };
  };
}
