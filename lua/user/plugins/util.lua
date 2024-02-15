local custom = {}

-- custom["m4xshen/hardtime.nvim"] = {
--    event = "BufReadPre",
--    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
--    opts = {}
-- }

custom["kylechui/nvim-surround"] = {
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	event = "VeryLazy",
	opts = {},
}

custom["mcookly/bidi.nvim"] = {
	event = "VeryLazy",
	opts = {},
}

return custom
