{ pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nightfox-nvim;
        type = "lua";
        config = ''
        require('nightfox').setup({
          options = {
          }
        })

        vim.cmd("colorscheme carbonfox")
        '';
      }
    ];
  };
}
