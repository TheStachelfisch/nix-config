{
  flake.modules.homeManager.vesktop =
    { pkgs, ... }:
    {
      programs.vesktop = {
        enable = true;
        package = pkgs.unstable.vesktop;
      };
    };

  # TODO: Remove once https://github.com/NixOS/nixpkgs/pull/542528 is merged and hit unstable
  flake.modules.nixos.system-desktop = {
    nixpkgs.config.permittedInsecurePackages = [
      "electron-40.10.5"
    ];
  };
}
