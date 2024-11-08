{pkgs, ...}: {
  programs.neovim = {
    extraPackages = with pkgs; [
      zls # ZIG language server
      nil # Nix language server
    ];

    plugins = with pkgs.vimPlugins; [
      # Language server configurations
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          local lspconfig = require('lspconfig')
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          lspconfig.zls.setup {
            capabilities = capabilities,
          }
          lspconfig.nil_ls.setup {
            capabilities = capabilities,
            settings = {
              ['nil'] = {
                formatting = {
                  command = { "nix format" },
                },
              },
            },
          }
        '';
      }
      {
        plugin = haste-nvim;
        type = "lua";
        config = ''
          require("haste").setup({
            url = "https://paste.ppeb.me/",
            setclip = true,
          })
        '';
      }

      # Snippets
      {
        plugin = luasnip;
        type = "lua";
        config = ''
          require("luasnip.loaders.from_vscode").lazy_load()
        '';
      }
      friendly-snippets

      # Completion
      cmp_luasnip
      cmp-buffer
      cmp-nvim-lsp
      lspkind-nvim
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
          end

          local cmp = require('cmp')
          local luasnip = require('luasnip')

          cmp.setup({
            snippet = {
              expand = function(args)
                luasnip.lsp_expand(args.body)
              end
            },
            formatting = {
              format = require('lspkind').cmp_format({
                mode = 'symbol_text',
                maxwidth = 75,
                ellipsis_char = '...',
                show_labelDetails = true,
              })
            },
            matching = {
              disallow_fuzzy_matching = false;
            },
            mapping = {
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              },
              ['<TAB>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                elseif has_words_before() then
                  cmp.close()
                else
                  fallback()
                end
              end, { "i", "s" }),
              ['<S-TAB>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" }),
              ['<ESC>'] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
              }),
            },
            experimental = {
              ghost_text = true;
            },
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'luasnip' },
            }, {
              { name = 'buffer', option = { get_bufnrs = vim.api.nvim_list_bufs } },
            })
          })

          cmp.setup.cmdline(':', {
            sources = cmp.config.sources({
              { name = 'path' },
              { name = 'cmdline' },
            })
          })

          cmp.setup.cmdline('/', {
            sources = {
              { name = "buffer" },
            }
          })
        '';
      }
    ];
  };
}
