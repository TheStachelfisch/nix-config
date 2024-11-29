{ config, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "me@thestachelfisch.dev";
    defaults.dnsProvider = "cloudflare";
    defaults.environmentFile = config.sops.secrets.cloudflare;
    defaults.dnsResolver = "1.1.1.1:53";
  };
}
