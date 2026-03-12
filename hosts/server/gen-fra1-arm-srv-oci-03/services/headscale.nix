{ config, ... }:
{
  imports = [
    ../../../common/optional/server/certs/thestachelfisch-dev.nix
  ];
  services.headscale = {
    enable = true;
    port = 8164;
    address = "127.0.0.1";
    settings = {
      server_url = "https://headscale.thestachelfisch.dev";
      dns = {
        base_domain = "ts.thestachelfisch.dev";
        override_local_dns = false;
      };
      prefixes = {
        v4 = "100.64.0.0/10";
        v6 = "fd7a:115c:a1e0::/48";
      };
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "headscale.thestachelfisch.dev" = {
        forceSSL = true;
        useACMEHost = "thestachelfisch.dev";
        locations = {
          "/" = {
            proxyPass = "http://localhost:${toString config.services.headscale.port}";
            proxyWebsockets = true;
          };
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
