{
  inputs,
  ...
}:
{
  flake.modules.nixos.system-server =
    {
      lib,
      ...
    }:
    {
      imports = with inputs.self.modules.nixos; [
        system-cli

        auto-upgrade
      ];

      time.timeZone = "UTC";
      boot.tmp.cleanOnBoot = true;

      # Not required on servers. Removes ~300MiB
      nix.registry = lib.mkForce { };
      nix.settings.flake-registry = "";
      documentation.nixos.enable = false;

      environment.enableAllTerminfo = true;

      security.sudo.wheelNeedsPassword = false;

      services.nginx = {
        recommendedTlsSettings = true;
        recommendedGzipSettings = true;
        recommendedOptimisations = true;
        recommendedProxySettings = true;
        recommendedUwsgiSettings = true;
        recommendedBrotliSettings = true;
      };

      services.tailscale.useRoutingFeatures = "server";
    };

  flake.modules.homeManager.system-server = {
    imports = with inputs.self.modules.homeManager; [
      system-cli
    ];
  };
}
