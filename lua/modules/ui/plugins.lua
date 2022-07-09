local ui = {}
local conf = require("modules.ui.config")

ui["kyazdani42/nvim-web-devicons"] = { opt = false }
ui["shaunsingh/nord.nvim"] = { opt = false, config = conf.nord }
ui["sainnhe/edge"] = { opt = false, config = conf.edge }
ui["catppuccin/nvim"] = {
	opt = false,
	as = "catppuccin",
	commit = "f079dda3dc23450d69b4bad11bfbd9af2c77f6f3",
	config = conf.catppuccin,
}
ui["rcarriga/nvim-notify"] = {
	opt = false,
	config = conf.notify,
}
ui["hoob3rt/lualine.nvim"] = {
	opt = true,
	after = "nvim-gps",
	config = conf.lualine,
}
ui["SmiteshP/nvim-gps"] = {
	opt = true,
	after = "nvim-treesitter",
	config = conf.nvim_gps,
}
ui["goolord/alpha-nvim"] = {
	opt = true,
	event = "BufWinEnter",
	config = conf.alpha,
}
ui["kyazdani42/nvim-tree.lua"] = {
	opt = true,
	cmd = { "NvimTreeToggle" },
	config = conf.nvim_tree,
}
ui["lewis6991/gitsigns.nvim"] = {
	opt = true,
	event = { "BufReadPost", "BufNewFile" },
	config = conf.gitsigns,
	requires = { "nvim-lua/plenary.nvim", opt = true },
}
ui["lukas-reineke/indent-blankline.nvim"] = {
	opt = true,
	event = "BufReadPost",
	config = conf.indent_blankline,
}
ui["akinsho/bufferline.nvim"] = {
	opt = true,
	tag = "*",
	event = "BufReadPost",
	config = conf.nvim_bufferline,
}
ui["dstein64/nvim-scrollview"] = {
	opt = true,
	event = { "BufReadPost" },
	config = conf.scrollview,
}
ui["mbbill/undotree"] = {
	opt = true,
	cmd = "UndotreeToggle",
}
ui["j-hui/fidget.nvim"] = {
	opt = true,
	event = "BufReadPost",
	config = conf.fidget,
}

return ui
