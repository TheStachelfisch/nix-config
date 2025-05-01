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
      gccgo14
      ripgrep

      nil
      inputs.zls.packages.x86_64-linux.zls
      lua-language-server
      nodejs_22
      typescript
      nodePackages_latest.typescript-language-server
      clang-tools
    ];
    # extraConfig = ''
    #   " Use system clipboard
    #   set clipboard+=unnamedplus
    #
    #   " Line numbers
    #   set number relativenumber
    #
    #   " 24 bit true colors
    #   set termguicolors
    #
    #   " Tabs
    #   set tabstop=4
    #   set expandtab
    #   set softtabstop=0
    #   set shiftwidth=0
    #   " 2 Character wide tab overrides
    #   augroup two_space_tab
    #   autocmd!
    #   autocmd FileType nix setlocal tabstop=2
    #   autocmd FileType lua setlocal tabstop=2
    #   augroup END
    #'';
  };

  # xdg.configFile.nvim = {
  #   source = ./config;
  #   recursive = true;
  # };
}
