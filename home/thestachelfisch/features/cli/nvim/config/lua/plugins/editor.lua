return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    ---@type wk.Opts
    opts = {
      preset = "modern",
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>c", group = "Code" },
          { "<leader>s", group = "Search" },
          { "<leader>f", group = "Find" },
          { "<leader>g", group = "Git" },
          { "g", group = "goto" },
          {
            "gb",
            group = "Buffer",
            expand = function ()
              return require("which-key.extras").expand.buf()
            end
          }
        },
      }
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "LazyFile",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
        smart_indent_cap = true,
      },
      exclude = { filetypes = { "help", "lazy", "Trouble", "trouble", "notify", "toggleterm" } },
    },
  },
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    version = false,
    opts = function(_)
      os.setlocale()
      -- don't use animate when scrolling with the mouse
      local mouse_scrolled = false
      for _, scroll in ipairs({ "Up", "Down" }) do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require("mini.animate")
      return {
        scroll = {
          subscroll =
            animate.gen_subscroll.equal({
              predicate = function(total_scroll)
                if mouse_scrolled then
                  mouse_scrolled = false
                  return false
                end
                return total_scroll > 1
              end,
            })
        },
      }
    end,
  },
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    version = "*",
    dependencies = {
      {
        "L3MON4D3/Luasnip",
        version = "v2.*",
        lazy = true,
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
            config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
            end
          }
        }
      },
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          }
        }
      },
    },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      sources = {
        default = { "lsp", "snippets", "path", "buffer" },
        per_filetype = {
          lua = { "lazydev", inherit_defaults = true },
        },
        providers = {
          lsp = {
            opts = { tailwind_color_icon = "󱓻" }
          },
          -- lua module integrations and completions from nvim/lazy
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- Show at higher priority than LSP
          },
        },
      },
      snippets = {
        preset = "luasnip",
      },
      keymap = {
        preset = "default"

        -- Disable all defaults
        -- preset = "none",
        -- ["<c-space>"] = { "show", "show_documentation", "hide_documentation" },
        -- ["<c-e>"] = { "cancel", "fallback" },
        -- ["<cr>"] = { "accept", "fallback" },
        --
        -- ["<tab>"] = {
        --   function(cmp)
        --     if not cmp.snippet_active() then return cmp.select_next() end
        --   end,
        --   "snippet_forward",
        --   "fallback",
        -- },
        --
        -- ["<s-tab>"] = {
        --   function (cmp)
        --     if not cmp.snippet_active() then return cmp.select_prev() end
        --   end,
        --   "snippet_backward",
        --   "fallback",
        -- },
        --
        -- ["<c-u>"] = { "scroll_documentation_up", "fallback" },
        -- ["<c-d>"] = { "scroll_documentation_down", "fallback" },
        --
        -- ["<c-k>"] = { "show_signature", "hide_signature", "fallback" },
      },
      completion = {
        menu = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
            border = "rounded",
          }
        },
        keyword = {
          range = "full",
        },
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
      },
      signature = {
        enabled = true,
        window = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
    },
  },
  {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      disable_mouse = false, -- Breaks scrolling
      disabled_keys = {
        ["<Left>"] = false,
        ["<Up>"] = false,
        ["<Right>"] = false,
        ["<Down>"] = false,
      },
      restricted_keys = {
        ["<Left>"] = { "n", "x" },
        ["<Up>"] = { "n", "x" },
        ["<Right>"] = { "n", "x" },
        ["<Down>"] = { "n", "x" },
      }
    }
  },
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function ()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function ()
          ---@diagnostic disable-next-line: duplicate-set-field
          vim.ui.select = function (...)
            require("lazy").load({ plugins = { "fzf-lua" } })
            require("fzf-lua").register_ui_select(nil)
            return vim.ui.select(...)
          end
        end
      })
    end,
    keys = {
      -- Default keys
      { "<leader><space>", "<cmd>FzfLua files<cr>", desc = "Find Files (Root Dir)" },
      { "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Grep (Root Dir)" },
      { "<leader>,", "<cmd>FzfLua buffers sort_mru=ture sort_lastused=true<cr>", desc = "Switch Buffers" },

      -- Find
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files (Root Dir)" },
      { "<leader>fF", "<cmd>FzfLua files cwd<cr>", desc = "Find Files (cwd)" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
      { "<leader>fR", "<cmd>FzfLua oldfiles cwd<cr>", desc = "Recent (cwd)" },

      -- Git
      { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Commits" },

      -- Search
      { "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
      { "<leader>sb", "<cmd>FzfLua grep_curbuf<cr>", desc = "Buffer" },
      { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
      { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfixes" },
      { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Quick fixes" },
      { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Diagnostics (Document)" },
      { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Diagnostics (Workspace)" },
      { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
      { "<leader>ss", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Symbols (Document)" },
      { "<leader>sS", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "Symbols (workspace)" },
    },
    opts = {
      fzf_colors = true,
      file_icon_padding = "",
      files = {
        hidden = false,
        fd_opts = [[--color=never --hidden --type f --type l --exclude .git --no-require-git]]
      },
      grep = {
        rg_opts = "--column --line-number --no-require-git --no-heading --color=always --smart-case --max-columns=4096 -e"
      }
    },
  },
  {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,
      float = {
        max_height = 0.8,
        max_width = 0.8,
      },
    },
    keys = {
      { "<leader>-", function() require("oil").toggle_float() end, desc = "Open Oil (Parent)" },
      { "<leader>_", function() require("oil").toggle_float(".") end, desc = "Open Oil (cwd)" },
    }
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
  }
}
