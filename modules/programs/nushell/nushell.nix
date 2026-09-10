{ inputs, ... }:
{
  flake.modules.nixos.nushell = { pkgs, ... }: {
    environment.shells = [
      pkgs.nushell
    ];
  };

  flake.modules.homeManager.nushell =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      key = "homeManager.nushell";
      imports = [ inputs.nix-index-database.homeModules.default ];

      programs.nushell = {
        enable = true;
        settings = {
          show_banner = false;
          use_kitty_protocol = true;

          history = {
            file_format = "sqlite";
            max_size = 100000;
            sync_on_enter = true;
            isolation = true;
          };
          completions = {
            algorithm = "fuzzy";
            sort = "smart";
            case_sensitive = false;
            quick = true;
            partial = true;
            use_ls_colors = true;
          };
        };
        extraConfig =
          let
            # I need to source the carapace script early in order to still use the completer defined by it
            carapaceBin = lib.getExe config.programs.carapace.package;
            carapaceNuConfig = pkgs.runCommand "carapace-nushell-config.nu" { } ''
              ${carapaceBin} _carapace nushell | sed 's|"/homeless-shelter|$"($env.HOME)|g' >> "$out"
            '';
          in
          /* nu */ ''
            source ${carapaceNuConfig} # Provides $carapace_completer

            let external_completers = {|spans|
              match $spans.0 {
                _ => $carapace_completer
              } | do $in $spans
            }

            $env.config.completions.external.completer = $external_completers
          '';
      };

      programs.carapace = {
        enable = true;
        enableNushellIntegration = false;
        # Available only in unstable home-manager options
        # environment = {
        #   CARAPACE_LENIENT = true;
        # };
      };

      programs.nix-index = {
        enable = true;
        package =
          inputs.nix-index-database.packages.${pkgs.stdenv.hostPlatform.system}.nix-index-with-small-db;
      };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableNushellIntegration = true;
      };
    };
}
