{
  flake.modules.nixos.gpg = {
    programs.gnupg = {
      agent = {
        enable = true;
      };
    };

    environment.sessionVariables = {
      PINENTRY_KDE_USE_WALLET = "1";
    };
  };

  flake.modules.homeManager.gpg =
    { pkgs, ... }:
    {
      programs.gpg = {
        enable = true;
      };

      # TODO: Enable only when KDE is used
      home.sessionVariables = {
        PINENTRY_KDE_USE_WALLET = "1";
      };

      services.gpg-agent = {
        enable = true;
        pinentry.package = pkgs.pinentry-qt;
        extraConfig = ''
          allow-preset-passphrase
          allow-loopback-pinentry
        '';
      };
    };
}
