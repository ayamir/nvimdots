local editor = {}

editor["rainbowhxch/accelerated-jk.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	config = function()
		require("modules.editor.acceleratedjk")
	end,
}
editor["rmagatti/auto-session"] = {
	lazy = true,
	cmd = { "SaveSession", "RestoreSession", "DeleteSession" },
	config = function()
		require("modules.editor.autosession")
	end,
}
editor["max397574/better-escape.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = function()
		require("modules.editor.betterescape")
	end,
}
editor["LunarVim/bigfile.nvim"] = {
	lazy = false,
	cond = require("core.settings").load_big_files_faster,
	config = function()
		require("modules.editor.bigfile")
	end,
}
editor["ojroques/nvim-bufdel"] = {
	lazy = true,
	event = "BufReadPost",
}
editor["rhysd/clever-f.vim"] = {
	lazy = true,
	event = "BufReadPost",
	config = function()
		require("modules.editor.cleverf")
	end,
}
editor["terrortylor/nvim-comment"] = {
	lazy = true,
	event = { "BufNewFile", "BufReadPre" },
	config = function()
		require("modules.editor.comment")
	end,
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
	config = function()
		require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
	end,
}
editor["RRethy/vim-illuminate"] = {
	lazy = true,
	event = "BufReadPost",
	config = function()
		require("modules.editor.illuminate")
	end,
}
-- only for fcitx5 user who uses non-English language during coding
-- editor["brglng/vim-im-select"] = {
-- 	lazy = true,
-- 	event = "BufReadPost",
-- 	config = function()
-- 		require("modules.editor.imselect")
-- 	end,
-- }
editor["karb94/neoscroll.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = function()
		require("modules.editor.neoscroll")
	end,
}
editor["ibhagwan/smartyank.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = function()
		require("modules.editor.smartyank")
	end,
}
editor["edluffy/specs.nvim"] = {
	lazy = true,
	event = "CursorMoved",
	config = function()
		require("modules.editor.specs")
	end,
}
editor["luukvbaal/stabilize.nvim"] = {
	lazy = true,
	event = "BufReadPost",
}
editor["akinsho/toggleterm.nvim"] = {
	lazy = true,
	event = "UIEnter",
	config = function()
		require("modules.editor.toggleterm")
	end,
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
	config = function()
		require("modules.editor.treesitter")
	end,
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects" },
		{ "p00f/nvim-ts-rainbow" },
		{ "JoosepAlviste/nvim-ts-context-commentstring" },
		{ "mfussenegger/nvim-ts-hint-textobject" },
		{ "andymass/vim-matchup" },
		{
			"windwp/nvim-ts-autotag",
			config = function()
				require("modules.editor.autotag")
			end,
		},
		{
			"NvChad/nvim-colorizer.lua",
			config = function()
				require("colorizer").setup()
			end,
		},
		{
			"abecodes/tabout.nvim",
			config = function()
				require("modules.editor.tabout")
			end,
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
	config = function()
		require("modules.editor.dap")
	end,
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			config = function()
				require("modules.editor.dapui")
			end,
		},
	},
}

return editor
