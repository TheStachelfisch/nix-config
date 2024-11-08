{
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    autocd = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "brackets"
      ];
    };
    autosuggestion.enable = true;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
      {
        name = "zsh-nix-shell";
        src = pkgs.zsh-nix-shell;
        file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
      }
    ];
    localVariables = {
      ZSH_AUTOSUGGEST_STRATEGY = ["match_prev_cmd" "completion"];
    };
  };
}
