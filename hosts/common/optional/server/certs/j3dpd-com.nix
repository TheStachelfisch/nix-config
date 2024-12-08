{ ... }: {
  imports = [
    ../acme.nix
  ];

  security.acme = {
    certs."j3dpd.com" = {
      extraDomainNames = ["*.j3dpd.com"];
      group = "nginx";
    };
  };
}
