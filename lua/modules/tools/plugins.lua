local tools = {}

tools["nvim-telescope/telescope.nvim"] = {
	lazy = true,
	cmd = "Telescope",
	config = function()
		require("modules.tools.telescope")
	end,
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-lua/popup.nvim" },
		{ "debugloop/telescope-undo.nvim" },
		{
			"ahmedkhalf/project.nvim",
			event = "BufReadPost",
			config = function()
				require("modules.tools.project")
			end,
		},
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "nvim-telescope/telescope-frecency.nvim", dependencies = {
			{ "kkharji/sqlite.lua" },
		} },
		{ "jvgrootveld/telescope-zoxide" },
		{ "nvim-telescope/telescope-live-grep-args.nvim" },
	},
}
tools["michaelb/sniprun"] = {
	lazy = true,
	build = "bash ./install.sh",
	cmd = { "SnipRun" },
	config = function()
		require("modules.tools.sniprun")
	end,
}
tools["folke/trouble.nvim"] = {
	lazy = true,
	cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
	config = function()
		require("modules.tools.trouble")
	end,
}
tools["gelguy/wilder.nvim"] = {
	lazy = true,
	event = "CmdlineEnter",
	config = function()
		require("modules.tools.wilder")
	end,
	dependencies = { { "romgrk/fzy-lua-native" } },
}
tools["mrjones2014/legendary.nvim"] = {
	lazy = true,
	cmd = "Legendary",
	config = function()
		require("modules.tools.legendary")
	end,
	dependencies = {
		{ "kkharji/sqlite.lua" },
		{
			"stevearc/dressing.nvim",
			event = "VeryLazy",
			config = function()
				require("modules.tools.dressing")
			end,
		},
		-- Please don't remove which-key.nvim otherwise you need to set timeoutlen=300 at `lua/core/options.lua`
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			config = function()
				require("modules.tools.whichkey")
			end,
		},
	},
}

return tools
