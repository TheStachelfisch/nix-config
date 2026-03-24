{
  flake.modules.nixos.firewall = {
    networking = {
      firewall = {
        enable = true;
        pingLimit = "2/second";
      };
      nftables.enable = true;
    };
  };
}
