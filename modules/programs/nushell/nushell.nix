{
  flake.modules.nixos.nushell = { pkgs, ... }: {
    environment.shells = [
      pkgs.nushell
    ];

    # Only launch if not login-shell
    programs.bash.interactiveShellInit = ''
      if ! [ "$TERM" = "dumb" ] && [ -z "$BASH_EXECUTION_STRING" ]; then
        exec nu
      fi
    '';
  };

  flake.modules.homeManager.nushell = {
    programs.nushell = {
      enable = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableNushellIntegration = true;
    };
  };
}
