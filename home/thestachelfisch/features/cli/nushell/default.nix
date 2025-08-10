{ config, lib, pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    extraConfig = /* nu */ ''
      $env.config.show_banner = false

      $env.PATH = ($env.PATH |
        split row (char esep) |
        append /usr/bin/env
      )

      # Returns a record of changed env variables after running a non-nushell script's contents (passed via stdin), e.g. a bash script you want to ""
      def capture-foreign-env [
        --shell (-s): string = /bin/sh
        # The shell to run the script in
        # (has to support '-c' argument and POSIX 'env', 'echo', 'eval' commands)
        --arguments (-a): list<string> = []
        # Additional command line arguments to pass to the foreign shell
      ] {
        let script_contents = $in;
        let env_out = with-env { SCRIPT_TO_SOURCE: $script_contents } {
          ^$shell ...$arguments -c `
          env
          echo '<ENV_CAPTURE_EVAL_FENCE>'
          eval "$SCRIPT_TO_SOURCE"
          echo '<ENV_CAPTURE_EVAL_FENCE>'
          env -u _ -u _AST_FEATURES -u SHLVL` # Filter out known changing variables
        }
        | split row '<ENV_CAPTURE_EVAL_FENCE>'
        | {
          before: ($in | first | str trim | lines)
          after: ($in | last | str trim | lines)
        }

        # Unfortunate Assumption:
        # No changed env var contains newlines (not cleanly parseable)
        $env_out.after
        | where { |line| $line not-in $env_out.before } # Only get changed lines
        | parse "{key}={value}"
        | transpose --header-row --as-record
      }

      if '__NIXOS_SET_ENVIRONMENT_DONE' not-in $env or $env.__NIXOS_SET_ENVIRONMENT_DONE != "1" { load-env (open /etc/set-environment | capture-foreign-env) }
      if '__HM_SESS_VARS_SOURCED' not-in $env or $env.__HM_SESS_VARS_SOURCED != "1" { load-env (open ~/.nix-profile/etc/profile.d/hm-session-vars.sh | capture-foreign-env) }

      let carapace_completer = {|spans: list<string>|
        carapace $spans.0 nushell ...$spans
        | from json
        | if ($in | default [] | where value == $"($spans | last)ERR" | is-empty) { $in } else { null }
      }

      $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

      let fish_completer = {|spans|
        ${lib.getExe pkgs.fish} --command $'complete "--do-complete=($spans | str join " ")"'
        | $"value(char tab)description(char newline)" + $in
        | from tsv --flexible --no-infer
      }

      # This completer will use carapace by default
      let external_completer = {|spans|
        let expanded_alias = scope aliases
        | where name == $spans.0
        | get -o 0.expansion

        let spans = if $expanded_alias != null {
          $spans
          | skip 1
          | prepend ($expanded_alias | split row ' ' | take 1)
        } else {
          $spans
        }

        match $spans.0 {
          # carapace completions are incorrect for nu
          nu => $fish_completer
          # fish completes commits and branch names in a nicer way
          git => $fish_completer
          _ => $carapace_completer
        } | do $in $spans
      }

      let command_not_found = { |cmd_name|
        let install = { |pkgs|
          $pkgs | each {|pkg| $"  nix shell nixpkgs#($pkg)" }
        }
        let run_once = { |pkgs|
          $pkgs | each {|pkg| $"  nix shell nixpkgs#($pkg) --command '($cmd_name) ...'" }
        }
        let single_pkg = { |pkg|
          let lines = [
            $"The program '($cmd_name)' is currently not installed."
            ""
            "You can install it by typing:"
            (do $install [$pkg] | get 0)
            ""
            "Or run it once with:"
            (do $run_once [$pkg] | get 0)
          ]
          $lines | str join "\n"
        }
        let multiple_pkgs = { |pkgs|
          let lines = [
            $"The program '($cmd_name)' is currently not installed. It is provided by several packages."
            ""
            "You can install it by typing one of the following:"
            (do $install $pkgs | str join "\n")
            ""
            "Or run it once with:"
            (do $run_once $pkgs | str join "\n")
          ]
          $lines | str join "\n"
        }
        let pkgs = (nix-locate --minimal --no-group --type x --type s --whole-name --at-root $"/bin/($cmd_name)" | lines)
        let len = ($pkgs | length)
        let ret = match $len {
          0 => null,
          1 => (do $single_pkg ($pkgs | get 0)),
          _ => (do $multiple_pkgs $pkgs),
        }
        return $ret
      }

      $env.config = {
        completions: {
          external: {
            enable: true
            completer: $external_completer
          }
        }
      }

      $env.config.hooks.command_not_found = $command_not_found
    '';
  };

  programs.carapace = {
    enable = true;
  };
}
