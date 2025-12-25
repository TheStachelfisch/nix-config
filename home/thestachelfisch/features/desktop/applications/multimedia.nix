{pkgs, ...}: {
  home.packages = with pkgs; [
    jellyfin-desktop
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
