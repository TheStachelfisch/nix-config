return {
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      vim.notify = require("notify")
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "SmiteshP/nvim-navic",
        opts = {
          depth_limit = 3,
          safe_output = true,
          lsp = {
            auto_attach = true,
            preference = { "vue_ls" },
          },
        },
      },
    },
    opts = function()
      -- "", "", "", "", "", ""
      local spec = require("nightfox.spec").load("carbonfox")
      local palette = spec.palette

      -- Shows the filename with the filetype icon besides it
      local filename_with_icon = require("lualine.components.filename"):extend()
      filename_with_icon.apply_icon = require("lualine.components.filetype").apply_icon
      filename_with_icon.icon_hl_cache = {}

      -- Shows the encoding the the fileformat besides it
      local encoding_with_fileformat = require("lualine.components.encoding"):extend()
      function encoding_with_fileformat:update_status()
        local symbols = {
          unix = '', -- e712
          dos = '', -- e70f
          mac = '', -- e711
        }

        local data = encoding_with_fileformat.super.update_status(self)
        local fileformat = symbols[vim.bo.fileformat]
        return fileformat .. " " .. data
      end

      -- Show recording messages
      local function recording()
        local reg = vim.fn.reg_recording()
        if reg ~= "" then
          return "Recording @" .. reg
        else
          return ""
        end
      end

      -- Amount of buffers
      local function buffer_amount()
        local listed_count = 0
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_get_option_value('buflisted', { buf = buf }) then
            listed_count = listed_count + 1
          end
        end

        return listed_count
      end

      local opts = {
        options = {
          theme = "auto",
          globalstatus = true,
        },
        extensions = { "fzf", "oil" },
        sections = {
          lualine_a = { { "mode", separator = { right = "" } }, { recording, separator = { right = "" } } },
          lualine_b = { { "branch", separator = { right = "" }, color = { bg = spec.bg0 } } },
          lualine_c = {
            { filename_with_icon, colored = true, separator = { right = "" }, color = { bg = spec.bg2, fg = spec.fg1 }, symbols = { modified = "", readonly = "" } },
            { "diagnostics", separator = { right = "" }, color = { bg = spec.bg1 } }
          },

          lualine_x = { { "navic", color = { bg = palette.white.base, fg = spec.bg0, gui = "bold" }, separator = { left = "" } }, { "filetype", color = { bg = spec.bg2, fg = spec.fg1 }, separator = { left = "" } } },
          lualine_y = { { encoding_with_fileformat, separator = { left = "" }} },
          lualine_z = { "location", "progress", "searchcount" },
        },
        tabline = {
          lualine_a = { { buffer_amount, separator = { right = "" } } },
        },
      }

      return opts
    end,
    config = function(_, opts)
      vim.o.cmdheight = 0
      require("lualine").setup(opts)
    end
  },
  {
    "akinsho/bufferline.nvim",
    enabled = false,
    dependencies = {
      { "nvim-web-devicons" },
    },
    event = "VeryLazy",
    keys = {
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = {
      options = {
        always_show_bufferline = false,
        show_close_icon = false,
        show_buffer_close_icons = false,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local icons = require("util.icons").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
      },
    }
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons"
    },
    cmd = "Neotree",
    keys = {
      {
        "<leader>e",
        function ()
          require("neo-tree.command").execute({  })
        end,
        desc = "File Explorer",
      }
    },
    opts = {
      sources = { "filesystem", "buffers" },
      close_if_last_window = true,
      open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      window = {
        mappings = {
          ["<space>"] = "none",
        },
        position = "right"
      },
    }
  },
  { "RRethy/vim-illuminate" },
  {
    "3rd/image.nvim",
    build = false,
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge, -- this is necessary for a good experience
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  }
}
