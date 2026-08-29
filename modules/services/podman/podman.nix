{
  flake.modules.nixos.podman =
    {
      pkgs,
      ...
    }:
    {
      virtualisation.podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
      };

      environment.systemPackages = with pkgs; [
        podman-compose
      ];
    };
}
