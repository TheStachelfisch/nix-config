{pkgs, ...}: {
  imports = [
    ./zsh
    ./nvim
    ./bat.nix
    ./git.nix
    ./gpg.nix
    ./direnv.nix
  ];

  # Smaller CLI tools
  home.packages = with pkgs; [
  ];
}
