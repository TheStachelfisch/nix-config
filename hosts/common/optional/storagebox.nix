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

  #systemd.mounts = [
  #{
  #Unit = {
  #  Description = "Personal Storagebox mount";
  #  Requires = [ "network-online.target" ];
  #  After = [ "network-online.target" "sops-nix.service" ];
  #};

  #Mount = {
  #What = "//u337764-sub1.your-storagebox.de/u337764-sub1";
  #Where = "/mnt/storagebox";
  #Options = "rw,credentials=${config.sops.secrets.personal-storagebox.path},uid=${config.users.users.stachel.uid},gid=${config.users.users.stachel.gid}";
  #Type = "cifs";
  #};
  #}
  #];

  fileSystems."/mnt/storagebox" = {
    device = "//u337764-sub1.your-storagebox.de/u337764-sub1";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in [ "${automount_opts},uid=1002,gid=100,credentials=${config.sops.secrets.personal-storagebox.path}" ];
  };
}
