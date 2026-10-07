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
              "x-systemd.automount"
              "noauto"
              "nofail"
              "x-systemd.idle-timeout=60"
              "x-systemd.device-timeout=5s"
              "x-systemd.mount-timeout=30s"
            ];
            permission_opts = "gid=${toString config.users.groups.mass-storage.gid},dir_mode=0770,file_mode=0660";
            security_opts = "vers=3.0,seal";
          in
          [
            "${automount_opts},${permission_opts},${security_opts},credentials=${
              config.sops.secrets."storage_boxes/personal".path
            }"
          ];
      };

      users.groups.mass-storage = {
        gid = 1005;
      };

      sops.secrets."storage_boxes/mass" = { };
    };
}
