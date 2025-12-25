{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    quickemu
    dnsmasq
  ];

  networking.firewall.trustedInterfaces = [
    "virbr0"
  ];

  systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };
  # programs.virt-manager.enable = true;
}
