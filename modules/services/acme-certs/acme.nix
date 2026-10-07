{
  flake.modules.nixos.acme = { config, ... }: {
    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "me@thestachelfisch.dev";
        dnsProvider = "cloudflare";
        environmentFile = config.sops.secrets."cloudflare/dns_api_token".path;
      };
    };

    sops.secrets."cloudflare/dns_api_token" = { };
  };
}
