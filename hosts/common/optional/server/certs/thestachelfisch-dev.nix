{...}: {
  imports = [
    ../acme.nix
  ];

  security.acme = {
    certs."thestachelfisch.dev" = {
      extraDomainNames = ["*.thestachelfisch.dev"];
      group = "nginx";
    };
  };
}
