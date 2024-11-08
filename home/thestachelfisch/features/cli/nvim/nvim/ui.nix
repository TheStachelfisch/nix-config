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
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          vim.g.nvim_tree_indent_markers = 1
          vim.g.nvim_tree_git_hl = 1
          vim.g.nvim_tree_width_allow_resize = 0
          vim.g.nvim_tree_add_trailing = 1
          vim.g.nvim_tree_group_empty = 1

          require("nvim-tree").setup({
          ignore_ft_on_setup = { ".git", "node_modules" },
          auto_close = true,
          tab_open = true,
          update_focused_file = {
            enable = true,
          },
          })
        '';
      }
    ];
  };
}
