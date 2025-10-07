return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = "*",
    build = ":TSUpdate",
    event = { "LazyFile", "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts = {
      auto_install = true,
      highlight = { enable = true },
      incremental_selection = {
        enable = true,
      },
      indent = { enable = true },
      ensure_installed = {
        "ini",
        "dockerfile",
        "csv",
        "embedded_template",
        "desktop",
        "json",
        "hjson",
        "diff",
        "jsonc",
        "nginx",
        "sql",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        "regex",
        "markdown",
        "markdown_inline",
        "make",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "lua",
        "luadoc",
        "luap",
        "query",
        "zig",
        "nix",
        "nu",
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "function" },
            ["if"] = { query = "@function.inner", desc = "function" },
            ["ac"] = { query = "@class.outer", desc = "class" },
            ["ic"] = { query = "@class.inner", desc = "class" },
            ["as"] = { query = "@local.scope", desc = "language scope" },
          },
        },
        move = {
          enable = true,
          goto_next_start = {
            ["]f"] = { query = "@function.outer", desc = "next function start" },
            ["]z"] = { query = "@fold", desc = "next fold" },
          },
          goto_next_end = {
            ["]F"] = { query = "@function.outer", desc = "next function end" }
          },
          goto_previous_start = {
            ["[f"] = { query = "@function.outer", desc = "prev function start" },
            ["[z"] = { query = "@fold", desc = "prev fold" },
          },
          goto_previous_end = {
            ["[F"] = { query = "@function.outer", desc = "prev function end" },
          }
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    config = function()
      -- Run Treesitter config again for textobjects
      local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
      if require("lazy.core.config").plugins["nvim-treesitter"]._.loaded then
        local opts = require("lazy.core.plugin").values(plugin, "opts", false)
        ---@diagnostic disable-next-line: missing-fields
        require("nvim-treesitter.configs").setup({ textobjects = opts.textobjects })
      end
    end
  },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  }
}
