# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../common/global
    ../common/users/thestachelfisch
  ];

  environment.systemPackages = with pkgs; [
    inputs.colmena.colmena
  ];

  wsl.enable = true;
  wsl.defaultUser = "thestachelfisch";

  networking.hostName = "wsl";
  networking.firewall.enable = false;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureUsers = [
      {
        name = "root";
        ensurePermissions = {
          "*.*" = "ALl PRIVILEGES";
        };
      }
    ];
  };

  systemd.services.mysql.wantedBy = lib.mkForce [];

  system.stateVersion = "24.05"; # Did you read the comment?
}
