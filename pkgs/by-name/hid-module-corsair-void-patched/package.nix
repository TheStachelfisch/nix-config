{
  lib,
  stdenv,
  kernel ? linux,
  linux,
}:
stdenv.mkDerivation rec {
  pname = "hid-module-corsair-void-patched";
  inherit (kernel)
    version
    src
    postPatch
    nativeBuildInputs
    ;

  modulePath = "drivers/hid";
  patches = [ ./corsair-hs70-pro.patch ];

  kernel_dev = kernel.dev;
  kernelVersion = kernel.modDirVersion;

  buildPhase = ''
    BUILT_KERNEL=$kernel_dev/lib/modules/$kernelVersion/build

    cp $BUILT_KERNEL/Module.symvers .
    cp $BUILT_KERNEL/.config        .
    cp $kernel_dev/vmlinux          .

    make "-j$NIX_BUILD_CORES" modules_prepare
    make "-j$NIX_BUILD_CORES" M=$modulePath modules
  '';

  installPhase = ''
    make \
      INSTALL_MOD_PATH="$out" \
      XZ="xz -T$NIX_BUILD_CORES" \
      M="$modulePath" \
      modules_install
  '';

  meta = with lib; {
    description = "Patched Corsair Void HID driver for HS70 Pro support";
    license = licenses.gpl2Only;
  };
}
