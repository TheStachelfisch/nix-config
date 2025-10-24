{ lib
, stdenv
, pkgs
, cmake
, cpm-cmake
, pkg-config
, glslang
, wrapQtAppsHook
, makeWrapper
, qttools
, vulkan-loader
, vulkan-headers
, vulkan-utility-libraries
, boost
, catch2_3
, cpp-jwt
, cubeb
, discord-rpc
, enet
, autoconf
, yasm
, libva
, nv-codec-headers-12
, ffmpeg-headless
, fmt
, libopus
, libusb1
, lz4
, nlohmann_json
, qtbase
, qtmultimedia
, qtwayland
, qtwebengine
, SDL2
, zlib
, zstd
}:
stdenv.mkDerivation (finalAttrs: rec {
  pname = "eden";
  version = "v0.0.3";

  src = pkgs.fetchFromGitea {
    domain = "git.eden-emu.dev";
    owner = "eden-emu";
    repo = "eden";
    rev = version;
    hash = "sha256-IZQ/xj+xHfcsWUUq4O4xZrssfFEestKuj68Aax8jHbI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    cpm-cmake
    pkg-config
    glslang
    wrapQtAppsHook
    makeWrapper
    qttools
  ];

  buildInputs = [
    vulkan-headers
    vulkan-utility-libraries
    boost
    catch2_3
    cpp-jwt
    cubeb
    discord-rpc
    enet
    autoconf
    yasm
    libva
    nv-codec-headers-12
    ffmpeg-headless
    fmt
    libopus
    libusb1
    lz4
    nlohmann_json
    qtmultimedia
    qtwayland
    qtwebengine
    SDL2
    zlib
    zstd
  ];

  dontFixCmake = true;

  cmakeFlags = [
    "-DYUZU_ENABLE_LTO=ON"
    "-DDYNAMIC_ENABLE_LTO=ON"
    # "-DYUZU_USE_FASTER_LD=ON"

    "-DENABLE_QT_TRANSLATION=ON"

    "-DYUZU_USE_BUNDLED_QT=OFF"
    "-DYUZU_USE_EXTERNAL_SDL2=ON"
    "-DYUZU_USE_EXTERNAL_VULKAN_HEADERS=OFF"
    "-DYUZU_USE_EXTERNAL_VULKAN_UTILITY_LIBRARIES=OFF"

    "-DYUZU_CHECK_SUBMODULES=OFF"

    "-DENABLE_QT=ON"
    "-DYUZU_USE_QT_WEB_ENGINE=ON"
    "-DYUZU_USE_QT_MULTIMEDIA=ON"
    "-DUSE_DISCORD_PRESENCE=ON"
    "-DENABLE_UPDATE_CHECKER=OFF"

    "-DENABLE_WEB_SERVICE=OFF"

    "-DYUZU_USE_CPM=OFF"
    "-DBOOST_NO_HEADERS=ON"
    "-DYUZU_USE_PRECOMPILED_HEADERS=ON"

    "-DYUZU_ENABLE_COMPATIBILITY_REPORTING=OFF"
    "-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF"
  ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib"
  ];
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isx86_64 "-march=native -mtune=native";

  postInstall = ''
    install -Dm444 $src/dist/72-yuzu-input.rules $out/lib/udev/rules.d/72-yuzu-input.rules
    '';
})
