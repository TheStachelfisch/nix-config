{
  flake.modules = {
    nixos.desktop-plasma =
      { pkgs, ... }:
      {
        services.desktopManager.plasma6.enable = true;
        services.displayManager.plasma-login-manager.enable = true;

        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        environment.systemPackages = with pkgs; [
          # Support for .rar and .7z files in Ark
          unrar
          p7zip
        ];
      };

    homeManager.desktop-plasma = { };
  };
}
