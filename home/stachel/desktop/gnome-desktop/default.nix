{ ... }:
{
  imports = [
    ../common
  ];

  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" "variable-refresh-rate" ];
    };
  };
}
