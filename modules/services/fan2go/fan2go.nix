{
  flake.modules.nixos.fan2go = { pkgs, ... }: {
    environment.systemPackages = with pkgs.unstable; [ fan2go ];

    systemd.services.fan2go = {
      description = "fan2go hardware fan control daemon";
      documentation = [ "https://github.com/markusressel/fan2go" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.unstable.fan2go}/bin/fan2go -c /etc/fan2go/fan2go.yaml --no-style";
        Restart = "always";
        RestartSec = 10;
      };
    };
  };
}
