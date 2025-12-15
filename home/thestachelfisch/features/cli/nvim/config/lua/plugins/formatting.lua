return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true })
				end,
				mode = { "n", "x" },
				desc = "Format Buffer",
			},
			{
				"<leader>cF",
				function()
					require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
				end,
				mode = { "n", "x" },
				desc = "Format Injected Languages",
			},
		},
		---@module "conform"
		---@type conform.setupOpts
		opts = {
			default_format_opts = {
				timeout_ms = 3000,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "biome", "biome-organize-imports" },
				javascriptreact = { "biome", "biome-organize-imports" },
				typescript = { "biome", "biome-organize-imports" },
				typescriptreact = { "biome", "biome-organize-imports" },
				php = { "php_cs_fixer" },
				sql = { "sqlfluff" },
			},
			format_after_save = {},
			formatters = {},
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},
}
