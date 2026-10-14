{
  lib,
  ...
}:
{
  flake.modules.nixos.mass-storagebox =
    {
      config,
      ...
    }:
    {
      fileSystems."/mnt/mass-storagebox" = {
        device = "//u337764.your-storagebox.de/backup";
        fsType = "cifs";
        options =
          let
            automount_opts = lib.concatStringsSep "," [
              "_netdev"
              "noauto"
              "nofail"
              "x-systemd.automount"
              "x-systemd.idle-timeout=600s"
              "x-systemd.device-timeout=10s"
              "x-systemd.mount-timeout=30s"
              "x-systemd.after=network-online.target"

              "hard"
              "echo_interval=15"
              "multichannel"
              "max_channels=4"
              "rsize=4194304"
              "wsize=4194304"
              "actimeo=30"
            ];
            permission_opts = "uid=0,forceuid,gid=${toString config.users.groups.mass-storage.gid},forcegid,noperm,dir_mode=0770,file_mode=0660";
            security_opts = "vers=3.1.1,seal";
          in
          [
            "${automount_opts},${permission_opts},${security_opts},credentials=${
              config.sops.secrets."storage_boxes/mass".path
            }"
          ];
      };

      users.groups.mass-storage = {
        gid = 1005;
      };

      sops.secrets."storage_boxes/mass" = { };
    };
}
