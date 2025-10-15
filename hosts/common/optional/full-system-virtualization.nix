{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    quickemu
    dnsmasq
  ];

  networking.firewall.trustedInterfaces = [
    "virbr0"
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };
  programs.virt-manager.enable = true;
}
