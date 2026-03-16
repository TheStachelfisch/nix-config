{ pkgs, ... }: {
  hardware.enableRedistributableFirmware = true;

  services.udev.extraRules = ''
    # Replace the idVendor and idProduct with your specific controller IDs
    # This rule triggers on 'add' and 'change' events to handle reconnects
    ACTION=="add|change", KERNEL=="event*", SUBSYSTEM=="input", ATTRS{idVendor}=="2dc8", ATTRS{idProduct}=="6012", RUN+="${pkgs.linuxConsoleTools}/bin/evdev-joystick --evdev /dev/input/%k --deadzone 0"
  '';
}
