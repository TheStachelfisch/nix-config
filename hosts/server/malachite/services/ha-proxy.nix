{...}: {
  imports = [
    ../../../common/optional/server/certs/j3dpd-com.nix
  ];

  services.nginx = {
    enable = true;

    virtualHosts."homeassistant.j3dpd.com" = {
      forceSSL = true;
      useACMEHost = "j3dpd.com";
      kTLS = true;

      locations = {
        "/" = {
          proxyPass = "http://home.j3dpd.com:8123";
          proxyWebsockets = true;
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
