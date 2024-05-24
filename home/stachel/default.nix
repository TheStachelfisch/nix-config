{ config, lib, inputs, outputs, pkgs, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./cli
    ./nvim
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  programs.home-manager.enable = true;

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  home = {
    username = lib.mkDefault "stachel";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "24.05";
    packages = [
      inputs.matugen.packages.${pkgs.system}.default
    ];
    # Set by the system configuration
    keyboard = null;
    sessionVariables = {
      NIXOS_OZONE_WL = 1;
    };
  };

  systemd.user.startServices = "sd-switch";
}
