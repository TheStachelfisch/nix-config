{
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak_dh";
  };

  console = {
    useXkbConfig = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Berlin";
  time.hardwareClockInLocalTime = true;
}
