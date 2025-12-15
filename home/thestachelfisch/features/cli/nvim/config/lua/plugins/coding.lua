return {
	{
		"altermo/ultimate-autopair.nvim",
		event = { "InsertEnter", "CmdlineEnter" },
		branch = "v0.6",
		opts = {},
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "LazyFile" },
		opts = {
			opts = {
				enable_close_on_slash = true,
			},
		},
	},
}
