local tools = {}
local conf = require("modules.tools.config")

tools["nvim-telescope/telescope.nvim"] = {
	lazy = true,
	cmd = "Telescope",
	config = conf.telescope,
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-lua/popup.nvim" },
		{ "debugloop/telescope-undo.nvim" },
		{ "ahmedkhalf/project.nvim", event = "BufReadPost", config = conf.project },
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
	-- You need to cd to `~/.local/share/nvim/site/lazy/sniprun/` and execute `bash ./install.sh`,
	-- if you encountered error about no executable sniprun found.
	build = "bash ./install.sh",
	cmd = { "SnipRun" },
	config = conf.sniprun,
}
tools["folke/trouble.nvim"] = {
	lazy = true,
	cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
	config = conf.trouble,
}
tools["gelguy/wilder.nvim"] = {
	lazy = true,
	event = "CmdlineEnter",
	config = conf.wilder,
	dependencies = { { "romgrk/fzy-lua-native" } },
}
tools["mrjones2014/legendary.nvim"] = {
	lazy = true,
	cmd = "Legendary",
	config = conf.legendary,
	dependencies = {
		{ "kkharji/sqlite.lua" },
		{ "stevearc/dressing.nvim", event = "VeryLazy", config = conf.dressing },
		-- Please don't remove which-key.nvim otherwise you need to set timeoutlen=300 at `lua/core/options.lua`
		{ "folke/which-key.nvim", event = "VeryLazy", config = conf.which_key },
	},
}

return tools
