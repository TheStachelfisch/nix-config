{
  pkgs,
  config,
  ...
}: {
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

  programs.gnome-shell = {
    enable = true;
    extensions = [
      {package = pkgs.gnomeExtensions.blur-my-shell;}
      {package = pkgs.gnomeExtensions.unblank;}
      {package = pkgs.gnomeExtensions.appindicator;}
      {package = pkgs.gnomeExtensions.just-perfection;}
      {package = pkgs.gnomeExtensions.wireless-hid;}
      {package = pkgs.gnomeExtensions.gsconnect;}
      {package = pkgs.gnomeExtensions.quick-settings-tweaker;}
      {package = pkgs.gnomeExtensions.rounded-window-corners-reborn;}
      {package = pkgs.gnomeExtensions.caffeine;}
      {package = pkgs.gnomeExtensions.notification-timeout;}
      {package = pkgs.gnomeExtensions.grand-theft-focus;}
    ];
  };

  gtk = {
    enable = true;
    theme = {
      # name = "adw-gtk${
      #   if config.dconf.settings."org/gnome/desktop/interface".color-scheme == "prefer-dark"
      #   then "-dark"
      #   else ""
      # }";
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };

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
        experimental-features = ["variable-refresh-rate" "scale-monitor-framebuffer" "xwayland-native-scaling" "autoclose-xwayland"];
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
