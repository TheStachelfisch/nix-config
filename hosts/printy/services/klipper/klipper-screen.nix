{
  pkgs,
  config,
  ...
}: {
  services.cage = {
    enable = true;
    package = pkgs.cage-patched;
    user = config.services.moonraker.user;
    extraArguments = [ "-d" ];
    program = "${pkgs.klipperscreen}/bin/KlipperScreen -c /etc/klipperscreen/KlipperScreen.conf -l /var/log/KlipperScreen/KlipperScreen.log";
  };
}
