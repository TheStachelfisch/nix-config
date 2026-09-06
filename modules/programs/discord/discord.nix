{
  flake.modules.homeManager.discord =
    { pkgs, ... }:
    {
      home.packages = with pkgs.unstable; [
        (discord.override {
          withVencord = true;
          withOpenASAR = true;
        })
      ];
    };
}
