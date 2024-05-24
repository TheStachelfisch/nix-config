{ pkgs, config, ... }:
{
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      package = pkgs.adwaita-qt;
      name = if config.theme.variant == "dark"
      then "adwaita-dark"  
      else "adwaita";
    };
  };
}
