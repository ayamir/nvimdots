local editor = {}

editor["rainbowhxch/accelerated-jk.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	opts = require("editor.accelerated-jk").opts,
	config = require("editor.accelerated-jk").config,
}
editor["olimorris/persisted.nvim"] = {
	lazy = true,
	cmd = {
		"SessionToggle",
		"SessionStart",
		"SessionStop",
		"SessionSave",
		"SessionLoad",
		"SessionLoadLast",
		"SessionLoadFromFile",
		"SessionDelete",
	},
	opts = require("editor.persisted").opts,
	config = require("editor.persisted").config,
}
editor["m4xshen/autoclose.nvim"] = {
	lazy = true,
	event = "InsertEnter",
	opts = require("editor.autoclose").opts,
	config = require("editor.autoclose").config,
}
editor["max397574/better-escape.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	opts = require("editor.better-escape").opts,
	config = require("editor.better-escape").config,
}
editor["LunarVim/bigfile.nvim"] = {
	lazy = false,
	opts = require("editor.bigfile").opts,
	config = require("editor.bigfile").config,
	cond = require("core.settings").load_big_files_faster,
}
editor["ojroques/nvim-bufdel"] = {
	lazy = true,
	cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
}
editor["rhysd/clever-f.vim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	opts = require("editor.cleverf").opts,
	config = require("editor.cleverf").config,
}
editor["numToStr/Comment.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	opts = require("editor.comment").opts,
	config = require("editor.comment").config,
}
editor["sindrets/diffview.nvim"] = {
	lazy = true,
	cmd = { "DiffviewOpen", "DiffviewClose" },
}
editor["junegunn/vim-easy-align"] = {
	lazy = true,
	cmd = "EasyAlign",
}
editor["smoka7/hop.nvim"] = {
	lazy = true,
	version = "*",
	event = { "CursorHold", "CursorHoldI" },
	opts = require("editor.hop").opts,
	config = require("editor.hop").config,
}
editor["RRethy/vim-illuminate"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	opts = require("editor.vim-illuminate").opts,
	config = require("editor.vim-illuminate").config,
}
editor["romainl/vim-cool"] = {
	lazy = true,
	event = { "CursorMoved", "InsertEnter" },
}
editor["lambdalisue/suda.vim"] = {
	lazy = true,
	cmd = { "SudaRead", "SudaWrite" },
	opts = require("editor.suda").opts,
	config = require("editor.suda").config,
}

----------------------------------------------------------------------
--                  :treesitter related plugins                    --
----------------------------------------------------------------------
editor["nvim-treesitter/nvim-treesitter"] = {
	lazy = true,
	build = function()
		if #vim.api.nvim_list_uis() ~= 0 then
			vim.api.nvim_command("TSUpdate")
		end
	end,
	event = "BufReadPost",
	opts = require("editor.treesitter").opts,
	config = require("editor.treesitter").config,
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects" },
		{ "JoosepAlviste/nvim-ts-context-commentstring" },
		{ "mfussenegger/nvim-treehopper" },
		{ "andymass/vim-matchup" },
		{
			"hiphish/rainbow-delimiters.nvim",
			opts = require("editor.rainbow_delims").opts,
			config = require("editor.rainbow_delims").config,
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
			opts = require("editor.ts-context").opts,
			config = require("editor.ts-context").config,
		},
		{
			"windwp/nvim-ts-autotag",
			config = require("editor.autotag"),
		},
		{
			"NvChad/nvim-colorizer.lua",
			opts = require("editor.colorizer").opts,
			config = require("editor.colorizer").config,
		},
		{
			"abecodes/tabout.nvim",
			opts = require("editor.tabout").opts,
			config = require("editor.tabout").config,
		},
	},
}

return editor