{ config, ... }:
let
  FIREFLY_PORT = 8961;
in 
{
  services.firefly-iii = {
    enable = true;
    enableNginx = true;
    settings = {
      SITE_OWNER = "contact@thestachelfisch.dev";
      APP_URL = "https://firefly.thestachelfisch.dev/";
      TRUSTED_PROXIES="**";
      APP_KEY_FILE = config.sops.secrets.firefly_app_key.path;
      ENABLE_EXTERNAL_MAP = true;
    };
  };

  services.nginx.virtualHosts.${config.services.firefly-iii.virtualHost}.listen = [{
    addr = "0.0.0.0";
    port = FIREFLY_PORT;
  }];

  services.cloudflared.tunnels."691ea66d-b4dd-4ec2-a4bb-0b98823eb2aa" = {
    ingress."firefly.thestachelfisch.dev" = {
      service = "http://127.0.0.1:${toString FIREFLY_PORT}";
    };
  };

  sops.secrets.firefly_app_key = {
    sopsFile = ../../../common/secrets.yaml;
    owner = config.services.firefly-iii.user;
    group = config.services.firefly-iii.group;
  };
}
