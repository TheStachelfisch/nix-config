{ pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      vim-nix
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup {
            auto_install = false;
            highlight = {
              enable = true;
              additional_vim_regex_highlighting = false;
            },
          }
        '';
      }
      {
        plugin = ultimate-autopair-nvim;
        type = "lua";
        config = ''
          local ultimateAutopair = require('ultimate-autopair')
          ultimateAutopair.setup({})
        '';
      }
      yuck-vim
    ];
  };
}
