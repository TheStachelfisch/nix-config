{ config, ... }:
{
  sops.secrets.wireless = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
  };

  networking.wireless.iwd = {
    enable = true;
    settings = {
      IPv6 = {
        Enabled = true;
      };
      Settings = {
        AutoConnect = true;
      };
    };
  };

  networking.networkmanager = {
    enable = true;
    wifi = {
      backend = "iwd";
      powersave = true;
    };
    ensureProfiles = {
      environmentFiles = [ config.sops.secrets.wireless.path ];
      profiles = {
        home-wifi = {
          connection = {
            id = "$SSID_HOME";
            type = "wifi";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "$SSID_HOME";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$PSK_HOME";
          };
        };
        eduroam = {
          "802-1x" = {
            ca-cert = "/etc/easyroam-certs/easyroam_root_ca.pem";
            client-cert = "/etc/easyroam-certs/easyroam_client_cert.pem";
            eap = "tls;";
            identity = "$IDENTITY_EDUROAM";
            private-key = "/etc/easyroam-certs/easyroam_client_key.pem";
            private-key-password = "$PSK_EDUROAM";
          };
          connection = {
            id = "eduroam";
            type = "wifi";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = { };
          wifi = {
            mode = "infrastructure";
            ssid = "eduroam";
          };
          wifi-security = {
            key-mgmt = "wpa-eap";
          };
        };
      };
    };
  };
}
