{ inputs, ... }:
{
  flake.modules.nixos.thestachelfisch-dev-cert = { config, ... }: {
    imports = with inputs.self.modules.nixos; [
      acme
    ];

    security.acme.certs."thestachelfisch.dev" = {
      extraDomainNames = [ "*.thestachelfisch.dev" ];
      # TODO: Evaluate if this should be kept or specified on a per-service basis
      group = "nginx";
    };
  };
}
