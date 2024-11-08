{ config, ... }:
{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        pad = "5x5 center";
        font = "monospace:size=8";
        selection-target = "clipboard";

        underline-offset = "1";
        underline-thickness = "1.1";
      };

      scrollback = {
        lines = 2500;
      };

      mouse = {
        hide-when-typing = "yes";
      };

      colors = {
        alpha = 0.85;
        background = "#000000";
        foreground = "#111111";
      };
    };
  };
}
