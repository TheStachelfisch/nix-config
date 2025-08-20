{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # ../../../common/optional/server/certs/thestachelfisch-dev.nix
    ./klipper-screen.nix
  ];

  services.klipper = {
    enable = true;
    mutableConfig = true;
    configFile = ./configs/printer.cfg;
    configDir = "/var/lib/moonraker/config";
    user = config.services.moonraker.user;
    group = config.services.moonraker.group;

    firmwares = {
      btt-octopus = {
<<<<<<< HEAD
        enable = false;
        configFile = ./configs/btt-octopus-firmware.cfg;   
=======
        enable = true;
        configFile = ./configs/btt-octopus-firmware.cfg;
>>>>>>> 64359ca150e19978b186b6726af42930ab38df6d
      };

      btt-sb2209-rp2040 = {
        enable = false;
        configFile = ./configs/btt-sb2209-rp2040-firmware.cfg;
      };
    };
  };

  systemd.network = {
    enable = lib.mkForce true;
    wait-online.enable = false;
    networks."can" = {
      matchConfig = {
        Name = "can*";
      };
      extraConfig =
        /*
        ini
        */
        ''
          [CAN]
          BitRate=1M
        '';
    };
  };
  services.udev.extraRules =
    /*
    udev
    */
    ''
      SUBSYSTEM=="net", ACTION=="change|add", KERNEL=="can*"  ATTR{tx_queue_len}="128"
    '';

  services.moonraker = {
    enable = true;
    # Currently broken
    # analysis.enable = true;
    allowSystemControl = true;
    settings = {
      authorization = {
        trusted_clients = [
          "10.0.0.0/24"
          "localhost"
        ];
      };

      octoprint_compat = {};
    };
  };

  services.mainsail = {
    enable = true;
    hostName = config.networking.hostName + ".thestachelfisch.dev";
    nginx = {
      # useACMEHost = "thestachelfisch.dev";
      kTLS = true;
    };
  };

  # For large gcode files
  services.nginx.clientMaxBodySize = "50m";

  networking.firewall.allowedTCPPorts = [80 443 config.services.moonraker.port];
}
