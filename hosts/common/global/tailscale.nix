{ config, lib, ... }:
{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = lib.mkDefault "client";
    extraUpFlags = ["--login-server ${config.services.headscale.settings.server_url}"];
  };

  # We trust it fully
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
