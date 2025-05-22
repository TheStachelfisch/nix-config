{
  pkgs,
  inputs,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      ripgrep

      lua-language-server
    ];
  };

  # xdg.configFile.nvim = {
  #   source = ./config;
  #   recursive = true;
  # };
}
