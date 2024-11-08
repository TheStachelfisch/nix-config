{lib, ...}: {
  networking = {
    firewall = {
      enable = lib.mkDefault true;
      pingLimit = "2/second";
    };
    nftables = {
      enable = true;
    };
    useNetworkd = false;
  };
  systemd.network = {
    enable = false;
  };
}
