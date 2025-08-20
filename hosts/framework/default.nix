{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  imports = [
    # Hardware imports
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    ./hardware-configuration.nix

    # Global imports
    ../common/global
    ../common/users/thestachelfisch

    # Optional imports
    ../common/optional/laptop
    ../common/optional/wireless.nix
    ../common/optional/storagebox.nix
    ../common/optional/full-system-virtualization.nix

    ../common/optional/desktop
    ../common/optional/desktop/gnome.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Disable panel self refresh to fix artifacts issues on eDP.
  # Shouldn't be needed with newer kernels at some point
  boot.kernelParams = [
    "amdgpu.dcdebugmask=0x410"
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="0E8D", ATTRS{idProduct}=="E616", MODE="0666"
  '';

  # TODO: Move to dedicated option for gaming peripherals
  hardware.xone.enable = true;

  hardware.framework.enableKmod = true;

  programs.nix-ld.enable = true;

  networking.hostName = "framework";
  services.fwupd.enable = true;
  services.libinput.enable = true;

  services.gnome.gnome-remote-desktop.enable = true;

  environment.systemPackages = with pkgs; [
    keepassxc
    nur.repos.ataraxiasjel.waydroid-script
    wineWowPackages.waylandFull

    pkgs.inputs.colmena.colmena
    # inputs.colmena.packages.x86_64-linux.colmena

    blender-hip
    samba

    moonlight-qt
  ];
  virtualisation.waydroid.enable = true;

  services.flatpak.enable = true;

  services.xserver.xkb.extraLayouts."EurKEY-Colemak" = {
    symbolsFile = ./EurKeyXKB;
    languages = ["eng" "ger"];
    description = "EurKEY Colemak layout";
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraPackages = with pkgs; [
      mangohud
    ];
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    extest.enable = true;
    gamescopeSession = {
      enable = true;
    };
  };

  # HIP Workaround
  systemd.tmpfiles.rules = let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [
        rocblas
        hipblas
        clr
      ];
    };
  in [
    "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  ];

  # OpenCL
  hardware.graphics.extraPackages = with pkgs; [rocmPackages.clr.icd];

  # Windows 10 virsual machine shared folder
  services.spice-webdavd.enable = true;

  services.postgresql = {
    enable = true;
    authentication = ''
      local all all trust
      host all all 0.0.0.0/0 trust
    '';
    ensureUsers = [
      {
        name = "postgres";
        ensureClauses = {
          superuser = true;
        };
      }
    ];
  };

  systemd.services.postgresql.wantedBy = lib.mkForce [];

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureUsers = [
      {
        name = "root";
        ensurePermissions = {
          "*.*" = "ALl PRIVILEGES";
        };
      }
    ];
  };

  systemd.services.mysql.wantedBy = lib.mkForce [];

  services.mongodb = {
    enable = true;
    package = pkgs.mongodb-ce;
    enableAuth = false;
  };
  systemd.services.mongodb.wantedBy = lib.mkForce [];

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  system.stateVersion = "24.05";
}
