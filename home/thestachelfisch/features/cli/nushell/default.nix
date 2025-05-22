{ config, ... }:
{
  programs.nushell = {
    enable = true;
    extraConfig = ''
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
      '';
  };
}
