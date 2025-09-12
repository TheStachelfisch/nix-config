{...}: {
  imports = [
    ./acme.nix
    ./nginx.nix
  ];

  environment.enableAllTerminfo = true;
}
