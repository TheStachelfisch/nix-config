{pkgs, lib, config, ...}: let
  orcaSlicerDesktopItem = pkgs.makeDesktopItem {
    name = "orca-slicer-zink";
    desktopName = "OrcaSlicer";
    genericName = "3D Printing Software";
    icon = "OrcaSlicer";
    exec = "env __GLX_VENDOR_LIBRARY_NAME=mesa __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json MESA_LOADER_DRIVER_OVERRIDE=zink GALLIUM_DRIVER=zink WEBKIT_DISABLE_DMABUF_RENDERER=1 ${pkgs.orca-slicer}/bin/orca-slicer %U";
    terminal = false;
    type = "Application";
    mimeTypes = [
      "model/stl"
      "model/3mf"
      "application/vnd.ms-3mfdocument"
      "application/prs.wavefront-obj"
      "application/x-amf"
      "x-scheme-handler/orcaslicer"
    ];
    categories = [ "Graphics" "3DGraphics" "Engineering" ];
    keywords = [ "3D" "Printing" "Slicer" "slice" "3D" "printer" "convert" "gcode" "stl" "obj" "amf" "SLA" ];
    startupNotify = false;
    startupWMClass = "orca-slicer";
  };

  mimeappsListContent = ''
    [Default Applications]
    model/stl=orca-slicer-dri.desktop;
    model/3mf=orca-slicer-dri.desktop;
    application/vnd.ms-3mfdocument=orca-slicer-dri.desktop;
    application/prs.wavefront-obj=orca-slicer-dri.desktop;
    application/x-amf=orca-slicer-dri.desktop;

    [Added Associations]
    model/stl=orca-slicer-dri.desktop;
    model/3mf=orca-slicer-dri.desktop;
    application/vnd.ms-3mfdocument=orca-slicer-dri.desktop;
    application/prs.wavefront-obj=orca-slicer-dri.desktop;
    application/x-amf=orca-slicer-dri.desktop;
  '';

  orcaSlicerMimeappsList = pkgs.writeText "orca-slicer-mimeapps.list" mimeappsListContent;
in {
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
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  programs.nix-ld.enable = true;

  networking.hostName = "desktop";
  services.fwupd.enable = true;
  services.libinput.enable = true;

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
        ids = ["1b1c:1b49:30224719"];
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
    wineWowPackages.waylandFull

    pkgs.inputs.colmena.colmena
    # inputs.colmena.packages.x86_64-linux.colmena

    moonlight-qt

    lsfg-vk
    vulkan-tools

    distrobox

    orcaSlicerDesktopItem

    (pkgs.heroic.override {
      extraPkgs = pkgs:
        with pkgs; [
          # gamescope
          gamemode
          mangohud
        ];
    })
  ];

  environment.sessionVariables = {
    FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
  };

  services.flatpak.enable = true;

  environment.etc."xdg/mimeapps.list".source = orcaSlicerMimeappsList;
  environment.etc."xdg/mimeapps.list".mode = "0644";

  security.lsm = lib.mkForce [ ];
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  services.xserver.xkb.extraLayouts."EurKEY-Colemak" = {
    symbolsFile = ./EurKeyXKB;
    languages = ["eng" "ger"];
    description = "EurKEY Colemak layout";
  };

  # TODO: Move to dedicated option for gaming peripherals
  hardware.xone.enable = true;
  programs.gamescope.enable = true;
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
