{ config, pkgs, lib, ... }:
{
  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    pinentryPackage =
      if config.gtk.enable 
      then pkgs.pinentry-gnome3
      else pkgs.pinentry-tty;
    };

   home.packages = lib.optional config.gtk.enable pkgs.gcr;

    programs.gpg = {
      enable = true;
    };
}
