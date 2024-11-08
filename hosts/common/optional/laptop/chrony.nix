{ ... }:
{
  # chrony is better for devices, which may not always be connected to the internet
  services.chrony = {
    enable = true;
  };
}
