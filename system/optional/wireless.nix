{ config, ... }:
{
  sops.secrets.wireless = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
  };

  networking.wireless = {
    enable = true;
    userControlled.enable = true;
    environmentFile = config.sops.secrets.wireless.path;
    networks = { 
      "@SSID_HOME@" = {
        psk = "@PSK_HOME@";
      };
    };
  };

  # networking.useNetworkd = true;
  # systemd.network.enable = true;
  # systemd.network.wait-online.enable = false;
}
