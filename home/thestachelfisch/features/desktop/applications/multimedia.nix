{pkgs, ...}: {
  home.packages = with pkgs; [
    # (jellyfin-media-player.override {
    #   mpv = mpv.override {
    #     scripts = with pkgs.mpvScripts; [
    #       mpris
    #     ];
    #   };
    # })
    showtime
  ];

  home.file.".local/share/jellyfinmediaplayer/scripts/mpris.so" = {
    source = "${pkgs.mpvScripts.mpris}/share/mpv/scripts/mpris.so";
    executable = true;
  };

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      mpris
    ];
  };
}
