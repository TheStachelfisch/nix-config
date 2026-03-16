{pkgs, lib, config, ...}: let
  hid-module = pkgs.callPackage ./hid-module/hid-module.nix {
    inherit (config.boot.kernelPackages) kernel;
  };
in
{
  imports = [
    # Hardware imports
    ./hardware-configuration.nix

    # Global imports
    ../common/global
    ../common/users/thestachelfisch

    # Optional imports
    ../common/optional/wireless.nix
    ../common/optional/storagebox.nix
    # ../common/optional/full-system-virtualization.nix

    ../common/optional/desktop
    ../common/optional/desktop/gnome.nix

    ../common/optional/full-system-virtualization.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [
    (hid-module.overrideAttrs (_: {
      patches = [ ./hid-module/hs-pro.patch ];
    }))
  ];
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  programs.nix-ld.enable = true;

  networking.hostName = "desktop";
  services.fwupd.enable = true;
  services.libinput.enable = true;

  fonts.packages = with pkgs; [
    poppins
    raleway
  ];

  boot.plymouth = {
    theme = "lone";
    themePackages = with pkgs; [
      (adi1090x-plymouth-themes.override {
        selected_themes = [ "lone" ];
      })
    ];
  };

  # Copy current monitors.xml into GDM
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${pkgs.writeText "monitors.xml" (builtins.readFile ./monitors.xml)}"
  ];

  # Dolphin USB passthrough
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0025", MODE="0666"
  '';

  services.keyd = {
    enable = true;
    keyboards = {
      corsair = {
        ids = ["1b1c:1b49:3d584d68"];
        settings = {
          main = {
            esc = "overload(capslock, esc)";
            capslock = "esc";
            leftalt = "layer(nav)";
          };
          "nav:A" = {
            h = "left";
            k = "up";
            j = "down";
            l = "right";
          };
        };
      };
    };
  };
  services.hardware.openrgb.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    keepassxc
    wineWow64Packages.waylandFull

    vulkan-hdr-layer-kwin6

    pkgs.inputs.colmena.colmena
    # inputs.colmena.packages.x86_64-linux.colmena

    moonlight-qt

    lsfg-vk
    vulkan-tools

    distrobox

    orca-slicer

    (pkgs.heroic.override {
      extraPkgs = pkgs:
        with pkgs; [
          # gamescope
          gamemode
          mangohud
        ];
    })
  ];

  # environment.sessionVariables = {
  #   FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
  # };

  services.flatpak.enable = true;

  security.lsm = lib.mkForce [ ];
  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  services.xserver.xkb.extraLayouts."EurKEY-Colemak" = {
    symbolsFile = ./EurKeyXKB;
    languages = ["eng" "ger"];
    description = "EurKEY Colemak layout";
  };

  # TODO: Move to dedicated option for gaming peripherals
  hardware.xone.enable = true;
  programs.gamescope = {
    enable = true;
    # capSysNice = true;
  };
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "auto";
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send -a Gamemode -i application-x-addon -e 'Gamemode being used'";
      };
    };
  };

  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraPkgs = pkgs': with pkgs'; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib # Provides libstdc++.so.6
        libkrb5
        keyutils
      ];
    };
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
      enable = false;
    };
  };

  system.stateVersion = "24.05";
}
