{ pkgs, ... }:
{
  home.packages = with pkgs; [ keepassxc ];
  # This doesn't launch with Wayland support for some reason, so only used as backup
  home.file.".local/share/dbus-1/services/org.freedesktop.secrets.service".text = ''
  [D-BUS Service]
  Name=org.freedesktop.secrets
  Exec=${pkgs.keepassxc}/bin/keepassxc -platform wayland
  '';
}
