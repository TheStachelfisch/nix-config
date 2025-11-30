{
  pkgs,
  config,
  ...
}: {
  services.cage = {
    enable = true;
    user = config.services.moonraker.user;
    program = "${pkgs.klipperscreen}/bin/KlipperScreen -c /etc/klipperscreen/KlipperScreen.conf";
  };
}
