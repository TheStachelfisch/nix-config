{ pkgs, ... }:
{
  imports = [
    ./zsh/zsh.nix
    ./git.nix
    ./gh.nix
    ./bat.nix
    ./gpg.nix
  ];

  home.packages = with pkgs; [
    socat
    jq
    python3
    brightnessctl
  ];
}
