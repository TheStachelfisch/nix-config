{
  flake.modules.nixos.openrgb =
    { pkgs, ... }:
    {
      services.hardware.openrgb = {
        enable = true;
        package = pkgs.unstable.openrgb;
      };
    };
}
