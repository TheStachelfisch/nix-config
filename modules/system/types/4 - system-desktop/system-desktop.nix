{
  inputs,
  ...
}:
{
  flake.modules.nixos.system-desktop = {
    imports = with inputs.self.modules.nixos; [
      system-cli
      quiet-boot

      wayland-pipewire-idle-inhibit

      colemak-keyboard
      ssh
      gpg
      xdg
      pipewire
      networkmanager
      keyd
      flatpak
      printing
    ];

    time.timeZone = "Europe/Berlin";
  };

  flake.modules.homeManager.system-desktop = {
    imports = with inputs.self.modules.homeManager; [
      system-cli

      xdg
      gpg
      git

      terminal
      keepassxc
      discord
      neovim

      firefox-browser
    ];
  };
}
