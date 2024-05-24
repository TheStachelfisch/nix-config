{ config, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    secrets.personal-storagebox = {};
    gnupg.home = "~/.gnupg";
  };

  # TODO: This fails if the network isn't online, find a workaround for the user to check for network availability
  systemd.user.mounts."mnt-storagebox" = {
    Unit = {
      Description = "Personal Storagebox mount";
      #Requires = [ "network-online.target" ];
      #After = [ "network-online.target" "sops-nix.service" ];
      After = [ "sops-nix.service" ];
    };

    Mount = {
      What = "//u337764-sub1.your-storagebox.de/u337764-sub1";
      Where = "/mnt/storagebox";
      Options = "rw,credentials=${config.sops.secrets.personal-storagebox.path}";
      Type = "cifs";
    };

    Install = {
      WantedBy = [ "multi-user.target" ];
    };
  };
}
