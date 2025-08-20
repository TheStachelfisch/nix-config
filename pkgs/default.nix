{pkgs}: rec {
  cartographer3d-plugin = pkgs.python312Packages.callPackage ./cartographer3d-plugin {};
}
