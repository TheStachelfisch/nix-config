{ pkgs, ... }:
{
  imports = [
    ./lsp.nix
    ./syntax.nix
    ./theme.nix
    ./ui.nix
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = '' 
      " Use system clipboard
      set clipboard+=unnamedplus

      " Line numbers
      set number relativenumber

      " 24 bit true colors
      set termguicolors

      " Tabs
      set tabstop=4
      set expandtab
      set softtabstop=0
      set shiftwidth=0
      " 2 Character wide tab overrides
      augroup two_space_tab
      autocmd!
      autocmd FileType nix setlocal tabstop=2
      augroup END
    '';
    plugins = with pkgs.vimPlugins; [
    ];
  };
}
