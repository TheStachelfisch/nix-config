{config, ...}: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "me@thestachelfisch.dev";
    defaults.dnsProvider = "cloudflare";
    defaults.environmentFile = config.sops.secrets.cloudflare.path;
  };

  sops.secrets.cloudflare = {
    sopsFile = ../../secrets.yaml;
  };
}
