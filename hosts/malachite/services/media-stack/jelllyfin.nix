{config, ...}: {
  imports = [
    ../../../common/optional/server/certs/thestachelfisch-dev.nix
  ];

  services.jellyfin = {
    enable = true;
  };

  users.users.jellyfin.extraGroups = [config.users.groups.mass-storage.name];

  # TODO: Add caching to config
  services.nginx = let
    jellyfin = "localhost:8096";
  in {
    enable = true;
    virtualHosts."jellyfin.thestachelfisch.dev" = {
      serverName = "newjellyfin.thestachelfisch.dev";
      forceSSL = true;
      useACMEHost = "thestachelfisch.dev";
      kTLS = true;

      locations = {
        "= /" = {
          return = "302 https://$host/web/";
        };

        "/" = {
          proxyPass = "http://${jellyfin}";
        };

        "= /web/" = {
          proxyPass = "http://${jellyfin}/web/index.html";
        };

        "/socket" = {
          proxyPass = "http://${jellyfin}";
          proxyWebsockets = true;
        };
      };

      extraConfig = ''
        client_max_body_size 100M;
      '';
    };
  };
}
