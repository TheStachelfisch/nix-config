{ inputs, ... }:
{
  flake.modules.nixos.thestachelfisch-dev-cert = { config, ... }: {
    imports = with inputs.self.modules.nixos; [
      acme
    ];

    security.acme.certs."j3dpd.com" = {
      extraDomainNames = [ "*.j3dpd.com" ];
      # TODO: Evaluate if this should be kept or specified on a per-service basis
      group = "nginx";
    };
  };
}
