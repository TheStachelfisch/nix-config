{ pkgs, config, ... }:
{
  gtk = {
    enable = true;
    theme = {
      package = pkgs.adw-gtk3;
      name = if config.theme.variant == "dark"
      then "adw-gtk3-dark"  
      else "adw-gtk3";
    };

    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface".color-scheme = if config.theme.variant == "dark" 
    then "prefer-dark"
    else "prefer-light";
  };
}
