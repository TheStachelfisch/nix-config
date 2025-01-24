{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    cemu
    dolphin-emu
    suyu
  ];
}
