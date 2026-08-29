{
  inputs,
  ...
}:
{
  flake.modules.nixos.system-minimal =
    { pkgs, config, ... }:
    {
      nixpkgs = {
        config.allowUnfree = true;
        overlays = [
          inputs.nur.overlays.default
          (_final: _prev: {
            unstable = import inputs.nixpkgs-unstable {
              system = pkgs.stdenv.hostPlatform.system;
              config = config.nixpkgs.config;
            };
          })
        ];
      };
      system.stateVersion = "26.05";

      hardware.enableRedistributableFirmware = true;

      nix = {
        channel.enable = false;

        registry = {
          nixpkgs.flake = inputs.nixpkgs;
          nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
        };

        settings = {
          substituters = [
            "https://cache.nixos.org?priority=10"
            "https://nix-community.cachix.org"
          ];

          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];

          experimental-features = [
            "nix-command"
            "flakes"
          ];

          trusted-users = [
            "root"
            "@wheel"
          ];

          use-xdg-base-directories = true;

          auto-optimise-store = true;
          download-buffer-size = 1024 * 1024 * 1024; # 1 GiB
          warn-dirty = false;
        };
      };
    };
}
