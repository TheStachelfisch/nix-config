{
  inputs,
  ...
}:
{
  flake.modules.nixos.gen-fra1-arm-srv-oci-03 =
    {
      config,
      ...
    }:
    {
      imports = with inputs.self.modules.nixos; [
        system-server

        mass-storagebox
        cloudflared
      ];

      services.cloudflared.tunnels."691ea66d-b4dd-4ec2-a4bb-0b98823eb2aa" = {
        credentialsFile =
          config.sops.secrets."cloudflare/691ea66d-b4dd-4ec2-a4bb-0b98823eb2aa-tunnel_creds".path;
        warp-routing.enabled = false;
        default = "http_status:404";
      };

      networking.hostName = "gen-fra1-arm-srv-oci-03";

      sops.secrets."cloudflare/691ea66d-b4dd-4ec2-a4bb-0b98823eb2aa-tunnel_creds" = { };
    };
}
