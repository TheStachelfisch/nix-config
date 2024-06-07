{ config, ... }:
{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        pad = "5x5 center";
        font = "monospace:size=8";
        selection-target = "clipboard";
      };

      scrollback = {
        lines = 2500;
      };

      mouse = {
        hide-when-typing = "yes";
      };

      colors = {
        alpha = 0.85;
        background = "${config.theme.colors.surface}";
        foreground = "${config.theme.colors.on_surface}";
      };
    };
  };
}
