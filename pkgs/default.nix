{pkgs}: rec {
  cartographer3d-plugin = pkgs.python3Packages.callPackage ./cartographer3d-plugin {};
}
