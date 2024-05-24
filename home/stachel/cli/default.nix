{ pkgs, ... }:
{
  imports = [
    ./zsh/zsh.nix
    ./git.nix
    ./bat.nix
    ./gpg.nix
  ];

  home.packages = with pkgs; [
    socat
    jq
    python3
    inotify-tools
  ];
}
