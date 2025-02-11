{pkgs, ...}: {
  imports = [
    ../../home/thestachelfisch
    # ../../home/thestachelfisch/features/desktop/plasma
    ../../home/thestachelfisch/features/desktop/gnome
  ];

  home.packages = with pkgs; [
    font-awesome
    powerline-fonts
    powerline-symbols
    nerd-fonts.symbols-only
  ];
}
