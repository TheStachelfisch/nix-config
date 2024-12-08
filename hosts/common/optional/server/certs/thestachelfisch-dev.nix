{ ... }: {
  imports = [
    ../acme.nix
  ];

  security.acme = {
    certs."thestachelfisch.com" = {
      extraDomainNames = ["*.thestachelfisch.com"];
      group = "nginx";
    };
  };
}
