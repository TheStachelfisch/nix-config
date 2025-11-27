{pkgs, inputs, ...}: {
  home.packages = with pkgs; [
    cemu
    dolphin-emu
    inputs.eden.packages.${pkgs.system}.eden

    alsa-oss

    (prismlauncher.override {
      gamemodeSupport = true;

      jdks = let
        oldPkgsGraal = import (builtins.fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/336eda0d07dc5e2be1f923990ad9fdb6bc8e28e3.tar.gz";
          sha256 = "sha256:0v8vnmgw7cifsp5irib1wkc0bpxzqcarlv8mdybk6dck5m7p10lr";
        }) {inherit (pkgs) system;};

        graalvm-ce-23 = oldPkgsGraal.graalvm-ce;
      in [
        graalvmPackages.graalvm-ce
        zulu25
        zulu17
      ];

      additionalPrograms = with pkgs; [ 
        gamescope
        mangohud
        alsa-oss
      ];
    })
  ];

  programs.mangohud = {
    enable = true;
  };
}
