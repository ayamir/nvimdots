local tools = {}

-- only for fcitx5 user who uses non-English language during coding
-- tool["brglng/vim-im-select"] = {
-- 	lazy = true,
-- 	event = "BufReadPost",
-- 	config = require("editor.imselect"),
-- }
tools["mrjones2014/legendary.nvim"] = {
	lazy = true,
	cmd = "Legendary",
	config = require("tools.legendary"),
	dependencies = {
		{ "kkharji/sqlite.lua" },
		{
			"stevearc/dressing.nvim",
			event = "VeryLazy",
			config = require("tools.dressing"),
		},
		-- Please don't remove which-key.nvim otherwise you need to set timeoutlen=300 at `lua/core/options.lua`
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			config = require("tools.which-key"),
		},
	},
}
tools["nvim-tree/nvim-tree.lua"] = {
	lazy = true,
	cmd = {
		"NvimTreeToggle",
		"NvimTreeOpen",
		"NvimTreeFindFile",
		"NvimTreeFindFileToggle",
		"NvimTreeRefresh",
	},
	config = require("tools.nvim-tree"),
}
tools["ibhagwan/smartyank.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("tools.smartyank"),
}
tools["michaelb/sniprun"] = {
	lazy = true,
	-- You need to cd to `~/.local/share/nvim/site/lazy/sniprun/` and execute `bash ./install.sh`,
	-- if you encountered error about no executable sniprun found.
	build = "bash ./install.sh",
	cmd = { "SnipRun" },
	config = require("tools.sniprun"),
}
tools["akinsho/toggleterm.nvim"] = {
	lazy = true,
	event = "UIEnter",
	config = require("tools.toggleterm"),
}
tools["folke/trouble.nvim"] = {
	lazy = true,
	cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
	config = require("tools.trouble"),
}
tools["gelguy/wilder.nvim"] = {
	lazy = true,
	event = "CmdlineEnter",
	config = require("tools.wilder"),
	dependencies = { "romgrk/fzy-lua-native" },
}

----------------------------------------------------------------------
--                        Telescope Plugins                         --
----------------------------------------------------------------------
tools["nvim-telescope/telescope.nvim"] = {
	lazy = true,
	cmd = "Telescope",
	config = require("tools.telescope"),
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-lua/popup.nvim" },
		{ "debugloop/telescope-undo.nvim" },
		{
			"ahmedkhalf/project.nvim",
			event = "BufReadPost",
			config = require("tools.project"),
		},
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "nvim-telescope/telescope-frecency.nvim", dependencies = {
			{ "kkharji/sqlite.lua" },
		} },
		{ "jvgrootveld/telescope-zoxide" },
		{ "nvim-telescope/telescope-live-grep-args.nvim" },
	},
}

----------------------------------------------------------------------
--                           DAP Plugins                            --
----------------------------------------------------------------------
tools["mfussenegger/nvim-dap"] = {
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
	config = require("tools.dap"),
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			config = require("tools.dap.dapui"),
		},
	},
}

return tools
