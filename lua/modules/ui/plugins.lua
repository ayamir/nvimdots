local ui = {}

ui["goolord/alpha-nvim"] = {
	lazy = true,
	event = "BufWinEnter",
	config = function()
		require("modules.ui.alpha")
	end,
}
ui["akinsho/bufferline.nvim"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = function()
		require("modules.ui.Bufferline")
	end,
}
ui["catppuccin/nvim"] = {
	lazy = false,
	name = "catppuccin",
	config = function()
		require("modules.ui.catppuccin")
	end,
}
ui["sainnhe/edge"] = {
	lazy = true,
	config = function()
		require("modules.ui.edge")
	end,
}
ui["j-hui/fidget.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = function()
		require("modules.ui.fidget")
	end,
}
ui["lewis6991/gitsigns.nvim"] = {
	lazy = true,
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("modules.ui.gitsigns")
	end,
}
ui["lukas-reineke/indent-blankline.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = function()
		require("modules.ui.indentblankline")
	end,
}
ui["nvim-lualine/lualine.nvim"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = function()
		require("modules.ui.lualine")
	end,
}
ui["zbirenbaum/neodim"] = {
	lazy = true,
	event = "LspAttach",
	config = function()
		require("modules.ui.neodim")
	end,
}
ui["shaunsingh/nord.nvim"] = {
	lazy = true,
	config = function()
		require("modules.ui.nord")
	end,
}
ui["rcarriga/nvim-notify"] = {
	lazy = true,
	event = "VeryLazy",
	config = function()
		require("modules.ui.notify")
	end,
}
ui["nvim-tree/nvim-tree.lua"] = {
	lazy = true,
	cmd = {
		"NvimTreeToggle",
		"NvimTreeOpen",
		"NvimTreeFindFile",
		"NvimTreeFindFileToggle",
		"NvimTreeRefresh",
	},
	config = function()
		require("modules.ui.nvimtree")
	end,
}
ui["dstein64/nvim-scrollview"] = {
	lazy = true,
	event = "BufReadPost",
	config = function()
		require("scrollview").setup({})
	end,
}

return ui
