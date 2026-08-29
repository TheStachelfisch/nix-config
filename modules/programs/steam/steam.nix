{ ... }:
{
  flake.modules.nixos.steam =
    { pkgs, ... }:
    {
      programs.gamemode = {
        enable = true;
        enableRenice = true;
        settings = {
          general = {
            softrealtime = "auto";
          };
          custom = {
            start = "${pkgs.libnotify}/bin/notify-send -a Gamemode -e 'Gamemode being used'";
          };
        };
      };

      programs.gamescope = {
        enable = true;
        capSysNice = true;
      };

      programs.steam = {
        enable = true;
        package = pkgs.unstable.steam;
        gamescopeSession.enable = false;
        extest.enable = true;

        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;

        extraPackages = with pkgs.unstable; [
          mangohud
        ];
        extraCompatPackages = with pkgs.unstable; [
          proton-ge-bin
          pkgs.nur.repos.vladexa.proton-cachyos-v3
        ];
      };
    };
}
