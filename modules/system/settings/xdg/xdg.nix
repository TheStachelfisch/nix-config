{ ... }:
{
  flake.modules = {
    nixos.xdg = {
      xdg.portal.xdgOpenUsePortal = true;
    };
    homeManager.xdg = {
      xdg = {
        enable = true;
        autostart.enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
          setSessionVariables = true;

          music = null;
          templates = null;
          publicShare = null;
        };
      };

      home.preferXdgDirectories = true;
    };
  };
}
