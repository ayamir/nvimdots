local completion = {}

completion["neovim/nvim-lspconfig"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("completion.lsp"),
	dependencies = {
		{ "mason-org/mason.nvim" },
		{ "mason-org/mason-lspconfig.nvim" },
		{ "folke/neoconf.nvim" },
		{
			"Jint-lzxy/lsp_signature.nvim",
			config = require("completion.lsp-signature"),
		},
	},
}
completion["nvimdev/lspsaga.nvim"] = {
	lazy = true,
	event = "LspAttach",
	config = require("completion.lspsaga"),
	dependencies = "nvim-tree/nvim-web-devicons",
}
completion["rachartier/tiny-inline-diagnostic.nvim"] = {
	lazy = false,
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
	event = { "InsertEnter", "CmdlineEnter" },
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
		{
			"fang2hou/blink-copilot",
			cond = require("core.settings").use_copilot,
			dependencies = {
				{
					"zbirenbaum/copilot.lua",
					lazy = true,
					cond = require("core.settings").use_copilot,
					cmd = "Copilot",
					event = "InsertEnter",
					config = require("completion.copilot"),
				},
			},
		},
	},
}

return completion
