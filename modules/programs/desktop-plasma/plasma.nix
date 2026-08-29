{
  flake.modules = {
    nixos.desktop-plasma = {
      services.desktopManager.plasma6.enable = true;
      services.displayManager.plasma-login-manager.enable = true;

      environment.sessionVariables.NIXOS_OZONE_WL = "1";
    };

    homeManager.desktop-plasma = { };
  };
}
