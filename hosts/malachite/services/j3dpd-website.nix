{...}: {
  imports = [
    ../../common/optional/server/certs/j3dpd-com.nix
  ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;

    virtualHosts."j3dpd.com" = {
      serverName = "j3dpd.com www.j3dpd.com";
      root = "/var/www/j3dpd.com";
      forceSSL = true;
      useACMEHost = "j3dpd.com";
      kTLS = true;

      locations = {
        "/maintenance" = {
          tryFiles = "$uri $uri/index.html =404";
        };

        "/" = {
          tryFiles = "$uri $uri/index.html =404";
        };

        "/404.html" = {
          return = "307 /maintenance";
        };
      };

      extraConfig = ''
        error_page 404 /404.html;
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
