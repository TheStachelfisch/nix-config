{ pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''
          require("ibl").setup {
            scope = {
              enabled = false;
            };
          };
        '';
      }
      {
        plugin = nvim-notify;
        type = "lua";
        config = ''
          require("notify").setup()
        '';
      }
    ];
  };
}
