{
  inputs,
  ...
}:
{
  flake.modules.nixos.system-desktop = {
    imports = with inputs.self.modules.nixos; [
      system-cli

      wayland-pipewire-idle-inhibit

      colemak-keyboard
      ssh
      gpg
      xdg
      pipewire
      networkmanager
      keyd
      flatpak
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
      browser
      keepassxc
      discord
      neovim
    ];
  };
}
