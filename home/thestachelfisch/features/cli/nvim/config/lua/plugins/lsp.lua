return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufRead", "BufNewFile" },
    keys = {
      {
        "ga",
        desc = "Go to code action",
        function ()
          vim.lsp.buf.code_action()
        end
      },
      {
        "gd",
        desc = "Go to definition",
        function ()
          vim.lsp.buf.definition()
        end
      },
      {
        "gD",
        desc = "Go to declaration",
        function ()
          vim.lsp.buf.declaration()
        end
      },
      {
        "gi",
        desc = "Go to implementation",
        function ()
          vim.lsp.buf.implementation()
        end
      },
      {
        "gr",
        desc = "Go to references",
        function ()
          vim.lsp.buf.references()
        end
      },
      {
        "K",
        desc = "Hover function",
        function ()
          vim.lsp.buf.hover()
        end
      },
    },
    config = function()
      local lspconfig = require("lspconfig")

      local border = {
        {"🭽", "FloatBorder"},
        {"▔", "FloatBorder"},
        {"🭾", "FloatBorder"},
        {"▕", "FloatBorder"},
        {"🭿", "FloatBorder"},
        {"▁", "FloatBorder"},
        {"🭼", "FloatBorder"},
        {"▏", "FloatBorder"},
      }

      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or border
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end

      lspconfig.lua_ls.setup {
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
            return
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
              }
            }
          })
        end,
        settings = {
          Lua = {}
        }
      }

      lspconfig.nil_ls.setup {
        settings = {
          ['nil'] = {
            formatting = {
              command = { "nix format" },
            },
          },
        },
      }

      lspconfig.zls.setup {
        filetypes = { "zig", "zir", "zon" }
      }
      lspconfig.clangd.setup {  }
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  }
}
