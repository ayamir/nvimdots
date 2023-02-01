local editor = {}

editor["rainbowhxch/accelerated-jk.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	config = require("editor.accelerated-jk"),
}
editor["rmagatti/auto-session"] = {
	lazy = true,
	cmd = { "SaveSession", "RestoreSession", "DeleteSession" },
	config = require("editor.auto-session"),
}
editor["max397574/better-escape.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("editor.better-escape"),
}
editor["LunarVim/bigfile.nvim"] = {
	lazy = false,
	config = require("editor.bigfile"),
	cond = require("core.settings").load_big_files_faster,
}
editor["ojroques/nvim-bufdel"] = {
	lazy = true,
	event = "BufReadPost",
}
editor["rhysd/clever-f.vim"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("editor.cleverf"),
}
editor["terrortylor/nvim-comment"] = {
	lazy = true,
	event = { "BufNewFile", "BufReadPre" },
	config = require("editor.nvim-comment"),
}
editor["sindrets/diffview.nvim"] = {
	lazy = true,
	cmd = { "DiffviewOpen", "DiffviewClose" },
}
editor["junegunn/vim-easy-align"] = {
	lazy = true,
	cmd = "EasyAlign",
}
editor["tpope/vim-fugitive"] = {
	lazy = true,
	cmd = { "Git", "G" },
}
editor["phaazon/hop.nvim"] = {
	lazy = true,
	branch = "v2",
	event = "BufReadPost",
	config = require("editor.hop"),
}
editor["RRethy/vim-illuminate"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("editor.vim-illuminate"),
}
-- only for fcitx5 user who uses non-English language during coding
-- editor["brglng/vim-im-select"] = {
-- 	lazy = true,
-- 	event = "BufReadPost",
-- 	config = require("editor.imselect"),
-- }
editor["karb94/neoscroll.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("editor.neoscroll"),
}
editor["ibhagwan/smartyank.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("editor.smartyank"),
}
editor["edluffy/specs.nvim"] = {
	lazy = true,
	event = "CursorMoved",
	config = require("editor.specs"),
}
editor["luukvbaal/stabilize.nvim"] = {
	lazy = true,
	event = "BufReadPost",
}
editor["akinsho/toggleterm.nvim"] = {
	lazy = true,
	event = "UIEnter",
	config = require("editor.toggleterm"),
}
editor["romainl/vim-cool"] = {
	lazy = true,
	event = { "CursorMoved", "InsertEnter" },
}

----------------------------------------------------------------------
--                  :treesitter related plugins                    --
----------------------------------------------------------------------
editor["nvim-treesitter/nvim-treesitter"] = {
	lazy = true,
	build = ":TSUpdate",
	event = "BufReadPost",
	config = require("editor.treesitter"),
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects" },
		{ "p00f/nvim-ts-rainbow" },
		{ "JoosepAlviste/nvim-ts-context-commentstring" },
		{ "mfussenegger/nvim-ts-hint-textobject" },
		{ "andymass/vim-matchup" },
		{
			"windwp/nvim-ts-autotag",
			config = require("editor.autotag"),
		},
		{
			"NvChad/nvim-colorizer.lua",
			config = require("editor.colorizer"),
		},
		{
			"abecodes/tabout.nvim",
			config = require("editor.tabout"),
		},
	},
}

----------------------------------------------------------------------
--                           DAP Plugins                            --
----------------------------------------------------------------------
editor["mfussenegger/nvim-dap"] = {
	lazy = true,
	cmd = {
		"DapSetLogLevel",
		"DapShowLog",
		"DapContinue",
		"DapToggleBreakpoint",
		"DapToggleRepl",
		"DapStepOver",
		"DapStepInto",
		"DapStepOut",
		"DapTerminate",
	},
	config = require("editor.dap"),
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			config = require("editor.dap.dapui"),
		},
	},
}

return editor
