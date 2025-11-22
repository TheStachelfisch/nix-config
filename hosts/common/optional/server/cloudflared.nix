{ config, ... }:
{
  services.cloudflared = {
    enable = true;
    certificateFile = config.sops.secrets.cloudflare_tunnel_cert.path;
    tunnels = {
      "691ea66d-b4dd-4ec2-a4bb-0b98823eb2aa" = {
        credentialsFile = config.sops.secrets."691ea66d-b4dd-4ec2-a4bb-0b98823eb2aa-tunnel_creds".path;
        warp-routing.enabled = false;
        default = "http_status:404";
      };
    };
  };

  boot.kernel.sysctl."net.core.rmem_max" = 7500000;
  boot.kernel.sysctl."net.core.wmem_max" = 7500000;

  sops.secrets = {
    cloudflare_tunnel_cert = {
      sopsFile = ../../secrets.yaml;
    };
    "691ea66d-b4dd-4ec2-a4bb-0b98823eb2aa-tunnel_creds" = {
      sopsFile = ../../secrets.yaml;
    };
  };
}
