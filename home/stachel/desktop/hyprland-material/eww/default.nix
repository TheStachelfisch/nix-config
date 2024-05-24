{ config, pkgs, ... }:
let
  config_dir = ./config;
  matugen_files = config.theme.files;
in
{
  programs.eww = {
    enable = true;
    configDir = pkgs.stdenv.mkDerivation {
      name = "combined-eww-configDir";
      dontUnpack = true;
      buildPhase = ''
        mkdir -p $out
        cp -r ${config_dir}/* $out/
        cp -r ${matugen_files}/eww/colors.scss $out/colors.scss
      '';
    };
  };


  theme.templates = {
    eww = {
      input_path = ./colors_template.scss;
      output_path = "eww/colors.scss";
    };
  };

  # Hacky workaround, since linking it into the same config dir as eww causes issues
  xdg.configFile."matugen-colors/colors.scss".source = "${config.theme.files}/eww/colors.scss";
}
