{pkgs, ...}: {
  imports = [
    ../applications
  ];

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    configPackages = with pkgs; [ xdg-desktop-portal-kde ];
    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    size = 24;
    package = pkgs.kdePackages.breeze;
    name = "breeze_cursors";
  };

  gtk = {
    enable = true;
  };
}
