{
  flake.modules = {
    nixos.desktop-plasma = {
      services.desktopManager.plasma6.enable = true;
    };

    services.displayManager.plasma-login-manager.enable = true;

    homeManager.desktop-plasma = { };
  };
}
