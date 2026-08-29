{
  flake.modules.homeManager.neovim =
    { pkgs, ... }:
    {
      programs.nvf.settings.vim = {
        options = {
          winborder = "rounded";
        };

        extraPlugins = {
          nightfox = {
            package = pkgs.vimPlugins.nightfox-nvim;
            setup = ''
              require('nightfox').setup({
                options = {
                  styles = {
                    comments = "italic";
                    keywords = "italic";
                  },
                },
                palettes = {
                  carbonfox = {
                    bg1 = "#000000",
                  },
                },
                groups = {
                  all = {
                    Pmenu = { bg = "bg0" },
                  },
                },
              })

              vim.cmd('colorscheme carbonfox')
            '';
          };
        };
      };
    };
}
