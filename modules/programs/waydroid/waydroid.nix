{
  flake.modules.nixos.waydroid = { pkgs, ... }: {
    virtualisation.waydroid = {
      enable = true;
      package = pkgs.unstable.waydroid-nftables;
    };
    environment.systemPackages = [
      pkgs.wl-clipboard
      pkgs.nur.repos.ataraxiasjel.waydroid-script
    ];
  };
}
