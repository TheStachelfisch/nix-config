{pkgs}: rec {
  cartographer3d-plugin = pkgs.python3Packages.callPackage ./cartographer3d-plugin {};
  eden = pkgs.qt6Packages.callPackage ./eden-emulator {};
}
