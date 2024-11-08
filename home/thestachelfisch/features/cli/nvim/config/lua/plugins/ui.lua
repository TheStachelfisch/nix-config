return {
  {
    'nanozuki/tabby.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      vim.o.showtabline = 2
    end,
  },
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    keys = {
      {
        "<leader>un",
        function ()
          require("notify").dismiss({ silent = true, pending = true, })
        end,
        desc = "Dismiss All Notifications",
      },
    },
    config = function ()
      vim.notify = require("notify")

      require("notify").setup({
        background_colour = "#000000",
        max_height = function() return math.floor(vim.o.lines * 0.75) end,
        max_width = function() return math.floor(vim.o.columns * 0.75) end,
        timeout = 3000,
      })
    end
  },
  {
    'goolord/alpha-nvim',
    event = "VimEnter",
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim'
    },
    config = function ()
      local alpha = require("alpha")
      local theta = require("alpha.themes.theta")
      local dashboard = require("alpha.themes.dashboard")

      theta.header.val =
      {
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                     ]],
        [[       ████ ██████           █████      ██                     ]],
        [[      ███████████             █████                             ]],
        [[      █████████ ███████████████████ ███   ███████████   ]],
        [[     █████████  ███    █████████████ █████ ██████████████   ]],
        [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
        [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
        [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
      }

      local section_projects = {
        type = "group",
        val = {
          {
            type = "text",
            val = "Recent Projects",
            opts = {
              hl = "SpecialComment",
              shrink_margin = false,
              position = "center",
            },
          },
          { type = "padding", val = 1 },
          {
            type = "group",
            val = {  },
            opts = { shrink_margin = false },
          }
        },
      }

      theta.buttons.val = {
        dashboard.button("e", "Test", ":qa<CR>")
      }

      theta.config.layout = {
        theta.header,
        { type = "padding", val = 2 },
        section_projects,
        { type = "padding", val = 2 },
        theta.buttons,
      }

      alpha.setup(theta.config)
    end
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      exclude = { filetypes = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" } },
    }
  }
}
