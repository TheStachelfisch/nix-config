{ inputs, ... }:
{
  flake.modules.nixos.wayland-pipewire-idle-inhibit = {
    imports = [ inputs.wayland-pipewire-idle-inhibit.nixosModules.default ];

    services.wayland-pipewire-idle-inhibit = {
      enable = true;
      settings = {
        verbosity = "INFO";
        idle_inhibitor = "dbus";
        node_blacklist = [
          { name = "[Ff]irefox"; } # Has its own working idle inhibit logic
          { name = "[Vv]esktop"; } # Discord Output stays active even after leaving a voice call
        ];
      };
    };
  };
}
