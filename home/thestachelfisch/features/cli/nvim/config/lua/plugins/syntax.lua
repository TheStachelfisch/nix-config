return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufRead", "BufNewFile" },
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "nix", "lua", "zig", "typescript", "javascript" },
        sync_install = false,

        highlight = {
          enable = true
        },

        indent = {
          enable = true
        },

        incremental_selection = {
          enable = true
        },
      })
    end,
  },
  {
    {
      "altermo/ultimate-autopair.nvim",
      event = { "InsertEnter","CmdlineEnter" },
      branch = "v0.6",
      opts = {
      },
    }
  }
}
