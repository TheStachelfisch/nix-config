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
    configDir = config.services.moonraker.stateDir + "/config";
    user = config.services.moonraker.user;
    group = config.services.moonraker.group;

    firmwares = {
      btt-octopus = {
        enable = false;
        configFile = ./configs/btt-octopus-firmware.cfg;
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
      networkConfig = {
        Description = "Default CANBus network";
        DHCP = "no";
        IPv6AcceptRA = "no";
      };
      linkConfig = {
        RequiredForOnline = "no";
        Unmanaged = "yes";
      };
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
          RestartSec=0
        '';
    };
  };

  systemd.services."setup-can0" = {
    description = "Configure can0 interface";
    after = [ "network-pre.target" ];
    wants = [ "network-pre.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = [
        "${pkgs.iproute2}/bin/ip link set can0 up"
      ];
      ExecStop = "${pkgs.iproute2}/bin/ip link set can0 down";
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
          "100.64.0.0/10"
          "10.0.0.0/24"
          "localhost"
        ];
      };
      octoprint_compat = {};
      file_manager = {};
      machine = {
        validate_service = false;
      };
      "power printer" = {
        type = "homeassistant";
        on_when_job_queued = true;
        locked_while_printing = true;
        bound_services = "klipper";
        address = "homeassistant.thestachelfisch.dev";
        protocol = "https";
        port = "443";
        token = "\{secrets.homeassistant.token\}";
        device = "switch.voron_3d_drucker";
      };
    };
  };

  services.mainsail = {
    enable = true;
    hostName = config.networking.hostName;
    nginx = {
      # useACMEHost = "thestachelfisch.dev";
      kTLS = true;
    };
  };

  # For large gcode files
  services.nginx.clientMaxBodySize = "50m";

  sops.secrets."moonraker.secrets" = {
    sopsFile = ../../printy_secrets.ini;
    format = "ini";
    path = config.services.moonraker.stateDir + "/moonraker.secrets";
    owner = config.services.moonraker.user;
  };
}
