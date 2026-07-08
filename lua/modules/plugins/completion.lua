local completion = {}
local settings = require("core.settings")

local edit_prediction_source = settings["edit-prediction-source"] or settings.edit_prediction_source
local use_copilot_prediction = settings.use_copilot and edit_prediction_source == "copilot"
local use_minuet_prediction = edit_prediction_source == "oai-compatible"

completion["mason-org/mason.nvim"] = {
	lazy = true,
	cmd = {
		"Mason",
		"MasonInstall",
		"MasonUninstall",
		"MasonUninstallAll",
		"MasonUpdate",
		"MasonLog",
	},
	config = require("completion.mason").setup,
}

completion["neovim/nvim-lspconfig"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("completion.lsp"),
	dependencies = {
		{ "mason-org/mason.nvim" },
		{ "mason-org/mason-lspconfig.nvim" },
		{ "folke/neoconf.nvim" },
	},
}
completion["nvimdev/lspsaga.nvim"] = {
	lazy = true,
	event = "LspAttach",
	config = require("completion.lspsaga"),
	dependencies = "nvim-tree/nvim-web-devicons",
}
completion["rachartier/tiny-inline-diagnostic.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	priority = 1000,
	config = require("completion.tiny-inline-diagnostic"),
}
completion["joechrisellis/lsp-format-modifications.nvim"] = {
	lazy = true,
	event = "LspAttach",
}
completion["nvimtools/none-ls.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("completion.null-ls"),
	dependencies = {
		"nvim-lua/plenary.nvim",
		"jay-babu/mason-null-ls.nvim",
	},
}
completion["saghen/blink.cmp"] = {
	lazy = true,
	version = "1.*",
	event = { "VeryLazy", "InsertEnter", "CmdlineEnter" },
	config = require("completion.blink"),
	dependencies = {
		{ "saghen/blink.compat", version = "2.*", opts = {} },
		{
			"L3MON4D3/LuaSnip",
			build = "make install_jsregexp",
			config = require("completion.luasnip"),
			dependencies = "rafamadriz/friendly-snippets",
		},
		{ "andersevenrud/cmp-tmux" },
		{ "f3fora/cmp-spell" },
		{ "kdheepak/cmp-latex-symbols" },
		{ "mikavilpas/blink-ripgrep.nvim" },
		{ "xzbdmw/colorful-menu.nvim" },
		{
			"milanglacier/minuet-ai.nvim",
			cond = use_minuet_prediction,
			config = require("completion.minuet"),
		},
		{
			"fang2hou/blink-copilot",
			cond = use_copilot_prediction,
			dependencies = {
				{
					"zbirenbaum/copilot.lua",
					lazy = true,
					cond = use_copilot_prediction,
					cmd = "Copilot",
					event = "InsertEnter",
					config = require("completion.copilot"),
				},
			},
		},
	},
	opts_extend = { "sources.default" },
}

completion["folke/lazydev.nvim"] = {
	lazy = true,
	ft = "lua",
	config = require("completion.lazydev"),
}

return completion
