{
  flake.modules.nixos.quiet-boot = {
    boot = {
      plymouth.enable = true;
      loader.timeout = 0;
      kernelParams = [
        "quiet"
        "loglevel=3"
        "systemd.show_status=auto"
        "rd.systemd.show_status=auto"

        "nowatchdog"
      ];
    };
  };
}
