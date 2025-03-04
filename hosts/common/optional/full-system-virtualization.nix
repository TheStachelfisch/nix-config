{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    quickemu
  ];

  virtualisation = {
    libvirtd = {
      enable = true; 
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  programs.virt-manager.enable = true;
}
