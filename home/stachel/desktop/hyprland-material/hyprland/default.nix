{ inputs, pkgs, config, ... }:
{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./binds.nix
    ./rules.nix
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gnome
    ];
    #xdgOpenUsePortal = true;
    configPackages = [ config.wayland.windowManager.hyprland.package ];
    config = {
      Hyprland = {
        default = [
          "hyprland"
          "gnome"
        ];
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
    };
    settings = {
      general = {
        border_size = 1;
        "col.active_border" = "rgba(${config.theme.colors.primary}88)";
        "col.inactive_border" = "rgba(00000000)";
      };
      exec = [
        "${pkgs.swaybg}/bin/swaybg -i ${config.theme.wallpaper} --mode fill"
      ];
      exec-once = [
        "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      ];
      input = {
        kb_layout = "us";
        kb_variant = "colemak_dh";
      };
      decoration = {
        rounding = 16;
        "col.shadow" = "rgba(${config.theme.colors.shadow}1a)";
        blur = {
          enabled = true;
          passes = 4;
          size = 12;
          #contrast = 1;
          #brightness = 1;
          #noise = 0.03;
          new_optimizations = true;
        };
      };
      misc = {
        vfr = true;
        vrr = 1;
      };
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };

      env = [
        "XCURSOR_SIZE,${builtins.toString (config.home.pointerCursor.size)}"
        "XCURSOR_THEME,${config.home.pointerCursor.name}"
      ];
    };
  };
}
