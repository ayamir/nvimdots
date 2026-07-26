local ui = {}
local settings = require("core.settings")

ui["nvim-lua/plenary.nvim"] = {
	lazy = true,
}
ui["folke/snacks.nvim"] = {
	lazy = false,
	priority = 1000,
	config = require("ui.snacks"),
}
ui["ayamir/nvchad-base46"] = {
	lazy = false,
	cond = settings.colorscheme == "nvchad",
	name = "nvchad-base46",
	branch = "v3.0",
	commit = "e0ff26ea85751f5e0da1f4704d636fcc236347b9",
	build = function()
		require("base46").load_all_highlights()
	end,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}
ui["ayamir/nvchad-ui"] = {
	lazy = false,
	cond = settings.colorscheme == "nvchad",
	name = "nvchad-ui",
	branch = "v3.0",
	commit = "d3eddf7cc85d70263f2bf9f872b19b4b1a0eb2f5",
	config = function()
		require("ui.nvchad").setup()
		require("nvchad")
	end,
	dependencies = {
		"ayamir/nvchad-base46",
		"nvim-tree/nvim-web-devicons",
	},
}

ui["akinsho/bufferline.nvim"] = {
	lazy = true,
	cond = settings.colorscheme ~= "nvchad",
	cmd = {
		"BufferLineCycleNext",
		"BufferLineCyclePrev",
		"BufferLineMoveNext",
		"BufferLineMovePrev",
		"BufferLineCloseOthers",
		"BufferLineSortByExtension",
		"BufferLineSortByDirectory",
		"BufferLineGoToBuffer",
	},
	event = { "BufReadPre", "BufAdd", "BufNewFile" },
	config = require("ui.bufferline"),
}
ui["Jint-lzxy/nvim"] = {
	lazy = false,
	branch = "refactor/syntax-highlighting",
	name = "catppuccin",
	cond = settings.colorscheme ~= "nvchad",
	config = require("ui.catppuccin"),
}
ui["lewis6991/gitsigns.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("ui.gitsigns"),
}
ui["nvim-lualine/lualine.nvim"] = {
	lazy = true,
	cond = settings.colorscheme ~= "nvchad",
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = require("ui.lualine"),
}
ui["folke/paint.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("ui.paint"),
}
ui["mrjones2014/smart-splits.nvim"] = {
	lazy = true,
	event = { "CursorHoldI", "CursorHold" },
	config = require("ui.splits"),
}
ui["folke/edgy.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("ui.edgy"),
}
ui["folke/todo-comments.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("ui.todo"),
	dependencies = "nvim-lua/plenary.nvim",
}
ui["dstein64/nvim-scrollview"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = require("ui.scrollview"),
}

return ui
