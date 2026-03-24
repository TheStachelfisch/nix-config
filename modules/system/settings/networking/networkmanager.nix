{
  flake.modules.nixos.networkmanager = {
    networking.networkmanager = {
      enable = true;
    };

    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
