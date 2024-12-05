{pkgs, ...}: {
  imports = [
    ../../home/thestachelfisch
    ../../home/thestachelfisch/features/desktop/plasma
  ];

  home.packages = with pkgs; [
    font-awesome
    powerline-fonts
    powerline-symbols
    nerd-fonts.symbols-only
  ];
}
