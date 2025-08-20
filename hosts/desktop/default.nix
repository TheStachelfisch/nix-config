{pkgs, config, ...}: {
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

  programs.nix-ld.enable = true;

  networking.hostName = "desktop";
  services.fwupd.enable = true;
  services.libinput.enable = true;

  # Copy current monitors.xml into GDM
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${pkgs.writeText "monitors.xml" (builtins.readFile ./monitors.xml)}"
  ];

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

  environment.systemPackages = with pkgs; [
    keepassxc
    wineWowPackages.waylandFull

    pkgs.inputs.colmena.colmena
    # inputs.colmena.packages.x86_64-linux.colmena

    moonlight-qt

    lsfg-vk
    vulkan-tools

    (pkgs.heroic.override {
      extraPkgs = pkgs:
        with pkgs; [
          # gamescope
          gamemode
          mangohud
        ];
    })
  ];
  services.flatpak.enable = true;

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
