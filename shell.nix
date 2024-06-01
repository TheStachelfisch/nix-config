{ pkgs ? import <nixpkgs> {}, ... }:
{
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-featues = nix-command flakes";
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git
      sops
      ssh-to-age
      gnupg
      age
    ];
  };
}
