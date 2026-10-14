{
  lib,
  ...
}:
{
  flake.modules.nixos.personal-storagebox =
    {
      config,
      ...
    }:
    {
      fileSystems."/mnt/personal-storagebox" = {
        device = "//u337764-sub1.your-storagebox.de/u337764-sub1";
        fsType = "cifs";
        options =
          let
            automount_opts = lib.concatStringsSep "," [
              "_netdev"
              "noauto"
              "nofail"
              "x-systemd.automount"
              "x-systemd.idle-timeout=60s"
              "x-systemd.device-timeout=5s"
              "x-systemd.mount-timeout=10s"
              "x-systemd.after=network-online.target"

              "soft"
              "retrans=1"
              "echo_interval=10"
              "actimeo=30"

              "x-gvfs-show"
            ];
            permission_opts = "uid=1000,gid=${toString config.users.groups.users.gid},dir_mode=0700,file_mode=0600";
            security_opts = "vers=3.1.1,seal";
          in
          [
            "${automount_opts},${permission_opts},${security_opts},credentials=${
              config.sops.secrets."storage_boxes/personal".path
            }"
          ];
      };

      sops.secrets."storage_boxes/personal" = { };
    };
}
