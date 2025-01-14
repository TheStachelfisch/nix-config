{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    cemu
    dolphin-emu
    pkgs.nur.repos.aprilthepink.suyu-mainline
  ];
}
