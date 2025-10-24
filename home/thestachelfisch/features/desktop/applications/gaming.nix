{pkgs, inputs, ...}: {
  home.packages = with pkgs; [
    cemu
    dolphin-emu
    inputs.suyu.packages.${pkgs.system}.suyu

    (prismlauncher.override {
      gamemodeSupport = true;

      jdks = let
        oldPkgsGraal = import (builtins.fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/336eda0d07dc5e2be1f923990ad9fdb6bc8e28e3.tar.gz";
          sha256 = "sha256:0v8vnmgw7cifsp5irib1wkc0bpxzqcarlv8mdybk6dck5m7p10lr";
        }) {inherit (pkgs) system;};

        graalvm-ce-23 = oldPkgsGraal.graalvm-ce;
      in [
        graalvm-ce-23
        zulu17
      ];

      additionalPrograms = let
        oldPkgsGamescope = import (builtins.fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/c5dd43934613ae0f8ff37c59f61c507c2e8f980d.tar.gz";
          sha256 = "sha256:1cpw3m45v7s7bm9mi750dkdyjgd2gp2vq0y7vr3j42ifw1i85gxv";
        }) {inherit (pkgs) system;};

        gamescope-old = oldPkgsGamescope.gamescope;
      in [
        gamescope-old
        mangohud
        alsa-oss
      ];
    })
  ];

  programs.mangohud = {
    enable = true;
  };
}
