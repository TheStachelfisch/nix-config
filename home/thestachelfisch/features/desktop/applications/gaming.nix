{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # cemu
    # dolphin-emu
    # config.nur.repos.aprilthepink.suyu-mainline
  ];
}
