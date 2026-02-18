{pkgs}: rec {
  cartographer3d-plugin = pkgs.python3Packages.callPackage ./cartographer3d-plugin {};
  cage-patched = pkgs.callPackage ./cage.nix {};
  orca-slicer = pkgs.callPackage ./orca-slicer {};
}
