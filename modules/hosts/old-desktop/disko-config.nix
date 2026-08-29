{ inputs, ... }:
{
  flake.modules.nixos.old-desktop = {
    imports = [ inputs.disko.nixosModules.disko ];

    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/nvme0n1";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                priority = 1;
                name = "ESP";
                start = "1M";
                end = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot/efi";
                  mountOptions = [ "umask=0077" ];
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  mountOptions = [
                    "ssd"
                    "discard=async"
                  ];
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd:1"
                        "noatime"
                      ];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [ "compress=zstd" ];
                    };
                    "@log" = {
                      mountpoint = "/var/log";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "@swap" = {
                      mountpoint = "/.swapvol";
                      mountOptions = [ "noatime" ];
                      swap = {
                        swapfile = {
                          size = "6G";
                        };
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
