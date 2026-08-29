{
  flake.modules.homeManager.keepassxc =
    { pkgs, ... }:
    {
      programs.keepassxc = {
        enable = true;
        package = pkgs.unstable.keepassxc;
        autostart = true;
      };
    };
}
