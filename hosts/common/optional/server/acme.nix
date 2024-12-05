{config, ...}: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "me@thestachelfisch.dev";
    defaults.dnsProvider = "cloudflare";
    defaults.environmentFile = config.sops.secrets.cloudflare.path;
    defaults.dnsResolver = "1.1.1.1:53";
  };

  sops.secrets.cloudflare = {
    sopsFile = ../../secrets.yaml;
  };
}
