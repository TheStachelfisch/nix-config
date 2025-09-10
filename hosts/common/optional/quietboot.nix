{ ... }: {
  console = {
    earlySetup = false;
  };

  boot = {
    plymouth = {
      enable = true;
    };
    loader.timeout = 0;
    kernelParams = [
      "quiet"
      "logo.nologo"
      "consoleblank=0"
      "loglevel=1"
      "systemd.show_status=auto"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"
      "plymouth.use-simpledrm"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };
}
