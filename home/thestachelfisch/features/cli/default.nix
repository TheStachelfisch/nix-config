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

  programs.nix-index.enable = true;

  programs.nh = {
    enable = true;
    flake = "/home/thestachelfisch/Documents/nix-config";
  };
}
