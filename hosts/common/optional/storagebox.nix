{
  config,
  pkgs,
  ...
}: {
  sops = {
    defaultSopsFile = ../secrets.yaml;
    secrets.personal-storagebox = {};
  };

  environment.systemPackages = with pkgs; [cifs-utils];

  fileSystems."/mnt/Storagebox" = {
    device = "//u337764-sub1.your-storagebox.de/u337764-sub1";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,nofail,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},uid=1000,gid=${toString config.users.groups.users.gid},credentials=${config.sops.secrets.personal-storagebox.path},comment=x-gvfs-show"];
  };
}
