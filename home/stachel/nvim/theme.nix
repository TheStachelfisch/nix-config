{ pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = onedark-nvim;
        type = "lua";
        config = ''
          require('onedark').setup {
            style = 'warmer'
          }
          require('onedark').load()
        '';
      }
    ];
  };
}
