return {
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    cmd = { "LspConfig", "LspInfo", "LspStart" },
    opts = {
      ---@type vim.diagnostic.Opts
      diagnostics = {
        underline = true,
        severity_sort = true,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = function (diagnostic, _, _)
            local icons = require("util.icons").icons.diagnostics
            for d, icon in pairs(icons) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
              ---@diagnostic disable-next-line: missing-return
            end
          end,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = require("util.icons").icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = require("util.icons").icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = require("util.icons").icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = require("util.icons").icons.diagnostics.Info,
          }
        }
      },
      inlay_hints = {
        enabled = true,
        exclude = { "lua" }
      },
      codelens = {
        enabled = true,
      },
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME
                },
              },
              codeLens = {
                enable = false,
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = true,
                paramType = true,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
        nil_ls = {
          settings = {
            ['nil'] = {
              flake = {
                nixpkgsInputName = "nixpkgs",
              }
            }
          }
        },
        zls = {
          settings = {
            zls = {
              semantic_tokens = "partial",
              build_on_save_args = {
                "-fincremental"
              },
            },
          }
        },
        vtsls = {
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
              typescript = {
                updateImportsOnFileMove = { enabled = "always" },
                suggest = {
                  completeFunctionCalls = true,
                },
                inlayHints = {
                  enumMemberValues = { enabled = true },
                  functionLikeReturnTypes = { enabled = true },
                  parameterNames = { enabled = "literals" },
                  parameterTypes = { enabled = true },
                  propertyDeclarationTypes = { enabled = true },
                  variableTypes = { enabled = false },
                },
              },
              tsserver = {
                globalPlugins = {
                  -- Vue
                  {
                    name = "@vue/typescript-plugin",
                    location = "/nix/store/3ha6w4sbv7fqpr7i1xhb15x11gfmvg23-vue-language-server-3.0.4/lib/language-tools/packages/language-server/",
                    languages = { "vue" },
                    configNamespace = "typescript",
                    enableForWorkspaceTypeScriptVersions = true,
                  },
                  -- Astro
                  {
                    name = "@astrojs/ts-plugin",
                    location = "/nix/store/q5040ci4qv6bx1xmia3vh1l22kl3x0ml-astro-language-server-2.15.4/lib/astro-language-server/packages/ts-plugin/",
                    enableForWorkspaceTypeScriptVersions = true,
                    configNamespace = "typescript",
                  }
                }
              }
            }
          },
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "astro" }
        },
        vue_ls = {
          init_options = {
            vue = {
              hybridMode = true,
            },
          },
        },
        tailwindcss = { },
        astro = { },
        ruff = { },
        basedpyright = { };
      },
    },
    config = function(_, opts)
      local lsp_util = require("util.lsp")
      local servers = opts.servers

      lsp_util.setup()

      for serverName, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts

          vim.lsp.config(serverName, server_opts)
          vim.lsp.enable(serverName, server_opts.enabled)
        end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- Codelens support
      if opts.codelens.enabled then
        lsp_util.on_supports_method("textDocument/codeLens", function (_, buffer)
          vim.lsp.codelens.refresh({ bufnr = buffer })
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = buffer,
            callback = vim.lsp.codelens.refresh,
          })
        end)
      end

      -- Inlay hints support
      if opts.inlay_hints.enabled then
        lsp_util.on_supports_method("textDocument/inlayHint", function (_, buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      -- Keymap
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP Keybind Actions",
        callback = function(_)
          local key = vim.keymap
          key.set("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", { desc = "Goto Definition" })
          key.set("n", "gD", "<cmd>FzfLua lsp_declarations<cr>", { desc = "Goto Declaration" })
          key.set("n", "gI", "<cmd>FzfLua lsp_implementations<cr>", { desc = "Goto Implementation" })
          key.set("n", "gr", "<cmd>FzfLua lsp_referencens<cr>", { desc = "Goto References" })
          key.set("n", "gy", "<cmd>FzfLua lsp_typedefs<cr>", { desc = "Goto T[y]pe definition" })
          key.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Action" })
          key.set("n", "<leader>cl", vim.lsp.codelens.run, { desc = "Run Codelens" })
          key.set("n", "<leader>cL", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })
          key.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Open Diagnostic" })
        end
      })

      -- Delete default global keybinds
      vim.keymap.del("n", "grn")
      vim.keymap.del("n", "gra")
      vim.keymap.del("n", "grr")
      vim.keymap.del("n", "gri")
      vim.keymap.del("n", "grt")
      vim.keymap.del("i", "<c-s>")

      -- Language specific actions
      -- ZIG autosave on InsertLeave
      vim.api.nvim_create_autocmd("InsertLeave", {
        pattern = { "*.zig", "*.zon" },
        callback = function ()
          vim.cmd("silent! write")
        end
      })

      -- ZIG organizeImports on save 
      -- vim.api.nvim_create_autocmd("BufWritePre", {
      --   pattern = { "*.zig", "*.zon" },
      --   callback = function (_)
      --     vim.lsp.buf.code_action({
      --       ---@diagnostic disable-next-line: missing-fields
      --       context = { only = { "source.organizeImports" } },
      --       apply = true,
      --     })
      --   end
      -- })
    end,
  },
  {
    "saecki/live-rename.nvim",
    opts = { },
    keys = {
      {
        "<leader>cr",
        function ()
          require("live-rename").rename({ insert = true })
        end,
        desc = "Rename"
      },
      {
        "<leader>cR",
        function ()
          require("live-rename").rename({ text = "", insert = true })
        end,
        desc = "Rename Replace"
      }
    }
  },
  -- LSP progress
  {
    "j-hui/fidget.nvim",
    opts = {
      progress = {  }
    },
  }
}
