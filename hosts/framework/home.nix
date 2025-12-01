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

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (
      ps: with ps; [
        nodejs_20
        jdk25
      ]
    );
  };
}
