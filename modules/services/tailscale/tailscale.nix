{
  flake.modules.nixos.tailscale = {
    services.tailscale = {
      enable = true;
      openFirewall = true;
    };

    systemd.services.tailscaled.serviceConfig.Environment = [ 
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];

    systemd.network.wait-online.enable = false; 
    boot.initrd.systemd.network.wait-online.enable = false;
  };
}
