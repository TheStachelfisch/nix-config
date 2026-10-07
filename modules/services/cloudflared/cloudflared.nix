{
  flake.modules.nixos.cloudflared = { config, ... }: {
    services.cloudflared = {
      enable = true;
      certificateFile = config.sops.secrets."cloudflare/tunnel_cert".path;
    };

    boot.kernel.sysctl = {
      "net.core.rmem_max" = 7500000;
      "net.core.wmem_max" = 7500000;
    };

    sops.secrets."cloudflare/tunnel_cert" = { };
  };
}
