{...}: {
  imports = [
    ./acme.nix
    ./nginx.nix
    ./cloudflared.nix
  ];

  environment.enableAllTerminfo = true;
}
