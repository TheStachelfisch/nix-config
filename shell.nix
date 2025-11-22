#{pkgs ? import <nixpkgs> {}, ...}: {
{pkgs, ...}: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git
      vim

      sops
      ssh-to-age
      gnupg
      age

      cloudflared
    ];
  };
}
