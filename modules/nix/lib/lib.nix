{
  inputs,
  lib,
  ...
}:
{
  # Helper functions for creating system / home-manager configurations
  # TODO: Convert to factory
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.lib = {
    mkNixos =
      {
        system,
        name,
        channel ? "stable",
      }:
      let
        baseChannel = if channel == "stable" then inputs.nixpkgs else inputs.nixpkgs-unstable;
        channelOverlay = final: prev: {
          unstable =
            if channel == "stable" then
              import inputs.nixpkgs-unstable {
                inherit (prev) system;
                inherit (prev) config;
              }
            else
              final;
        };
      in
      {
        ${name} = baseChannel.lib.nixosSystem {
          modules = [
            inputs.self.modules.nixos.${name}
            {
              nixpkgs.hostPlatform = lib.mkDefault system;
              nixpkgs.overlays = [ channelOverlay ];
            }
          ];
        };
      };

    # For standalone setup. For use on non-NixOS distros
    mkHomeManager = system: name: {
      ${name} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
        modules = [
          inputs.self.modules.homeManager.${name}
          { nixpkgs.config.allowUnfree = true; }
        ];
      };
    };
  };
}
