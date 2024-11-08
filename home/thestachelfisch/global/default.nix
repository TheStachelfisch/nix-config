{ pkgs, config, lib, inputs, outputs, ... }:
{
  imports = [
    ../features/cli
  ]; 
  #++ (builtins.attrValues outputs.homeManagerModules);

  programs.home-manager.enable = true;

  home = {
    username = lib.mkDefault "thestachelfisch";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "24.05";
    keyboard = null;
  };

  systemd.user.startServices = "sd-switch";
}
