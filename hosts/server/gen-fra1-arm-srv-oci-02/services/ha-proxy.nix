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
          proxyPass = "http://$target_host:8123";
          proxyWebsockets = true;
          extraConfig = ''
            resolver 8.8.8.8 valid=1m;
            set $target_host home.j3dpd.com ;
          '';
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
