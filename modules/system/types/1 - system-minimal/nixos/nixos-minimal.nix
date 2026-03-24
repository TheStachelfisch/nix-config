{
  inputs,
  ...
}:
{
  flake.modules.nixos.system-minimal =
    { pkgs, ... }:
    {
      nixpkgs = {
        config.allowUnfree = true;
      };
      system.stateVersion = "25.11";

      nix = {
        channel.enable = false;
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

          auto-optimise-store = true;
          download-buffer-size = 1024 * 1024 * 1024; # 1 GiB
          warn-dirty = false;
        };
      };
    };
}
