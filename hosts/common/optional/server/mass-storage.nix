{
  config,
  pkgs,
  ...
}: {
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    secrets.mass-storagebox = {};
  };

  environment.systemPackages = with pkgs; [cifs-utils];

  fileSystems."/mnt/mass-storagebox" = {
    device = "//u337764.your-storagebox.de/backup";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,file_mode=0660,dir_mode=0770";
    in ["${automount_opts},gid=${toString config.users.groups.mass-storage.gid},credentials=${config.sops.secrets.mass-storagebox.path}"];
  };

  users.groups.mass-storage = { gid = 1005; };
}
