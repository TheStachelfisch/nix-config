{ config, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "${pkgs.foot}/bin/foot";
    # TODO: Replace with global font configurations
    font = "Roboto Flex Nerd Font 12";
  };

  home.file.".local/share/rofi/themes" = {
    recursive = true;
    source = ./themes;
  };

  theme.templates = {
    rofi = {
      input_path = ./colors_template.rasi;
      output_path = "rofi/colors.rasi";
    };
  };

  home.file.".local/share/rofi/themes/colors.rasi".source = "${config.theme.files}/rofi/colors.rasi";
}
