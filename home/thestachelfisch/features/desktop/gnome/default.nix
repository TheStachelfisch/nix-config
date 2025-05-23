{ pkgs, ... }:
{
  imports = [
    ../applications
  ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
  };

  services.gnome-keyring.enable = true;

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };

  home.packages = with pkgs.gnomeExtensions; [
    blur-my-shell
    unblank
    appindicator
    just-perfection
    search-light
    quick-settings-tweaker
    wireless-hid
  ];

  gtk.enable = true;

  qt = {
    enable = true;
    platformTheme = {
      name = "adwaita";
    };
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/mutter" = {
        experimental-features = [ "variable-refresh-rate" "scale-monitor-framebuffer" "xwayland-native-scaling" "autoclose-xwayland" ];
      };

      "org/gnome/shell" = {
        enabled-extensions = [
          "drive-menu@gnome-shell-extensions.gcampax.github.com"
          "blur-my-shell@aunetx"
          "unblank@sun.wxg@gmail.com"
          "appindicatorsupport@rgcjonas.gmail.com"
          "places-menu@gnome-shell-extensions.gcampax.github.com"
          "just-perfection-desktop@just-perfection"
          "quick-settings-tweaks@qwreey"
          "wireless-hid@chlumskyvaclav.gmail.com"
        ];
      };

      "org/gnome/desktop/interface" = {
        accent-color = "blue";
        color-scheme = "prefer-dark";
        show-battery-percentage = true;
      };

      "org/gnome/desktop/wm/preferences" = {
        resize-with-right-button = true;
      };
    };
  };
}
