local completion = {}

completion["neovim/nvim-lspconfig"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	opts = require("completion.lsp").opts,
	config = require("completion.lsp").config,
	dependencies = {
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{
			"ray-x/lsp_signature.nvim",
			opts = require("completion.lsp-signature").opts,
			config = require("completion.lsp-signature").config,
		},
	},
}
completion["nvimdev/lspsaga.nvim"] = {
	lazy = true,
	event = "LspAttach",
	opts = require("completion.lspsaga").opts,
	config = require("completion.lspsaga").config,
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
completion["jose-elias-alvarez/null-ls.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	opts = require("completion.null-ls").opts,
	config = require("completion.null-ls").config,
	dependencies = {
		{"nvim-lua/plenary.nvim"},
		{
			"jay-babu/mason-null-ls.nvim",
			opts = require("completion.mason-null-ls").opts,
			config = require("completion.mason-null-ls").config,
		},
	},
}
completion["hrsh7th/nvim-cmp"] = {
	lazy = true,
	event = "InsertEnter",
	opts = require("completion.cmp").opts,
	config = require("completion.cmp").config,
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			dependencies = { "rafamadriz/friendly-snippets" },
			opts = require("completion.luasnip").opts,
			config = require("completion.luasnip").config,
		},
		{ "lukas-reineke/cmp-under-comparator" },
		{ "saadparwaiz1/cmp_luasnip" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-nvim-lua" },
		{ "andersevenrud/cmp-tmux" },
		{ "hrsh7th/cmp-path" },
		{ "f3fora/cmp-spell" },
		{ "hrsh7th/cmp-buffer" },
		{ "kdheepak/cmp-latex-symbols" },
		{ "ray-x/cmp-treesitter", commit = "c8e3a74" },
		{
			"tzachar/cmp-tabnine",
			enabled = false,
			build = "./install.sh",
			opts = require("completion.tabnine").opts,
			config = require("completion.tabnine").config
		},
		{
			"jcdickinson/codeium.nvim",
			enabled = false,
			dependencies = {
				"nvim-lua/plenary.nvim",
				"MunifTanjim/nui.nvim",
			},
			opts = require("completion.codeium").opts,
			config = require("completion.codeium").config,
		},
	},
}
completion["zbirenbaum/copilot.lua"] = {
	lazy = true,
	cmd = "Copilot",
	event = "InsertEnter",
	opts = require("completion.copilot").opts,
	config = require("completion.copilot").config,
	dependencies = {
		{
			"zbirenbaum/copilot-cmp",
			opts = require("completion.copilot-cmp").opts,
			config = require("completion.copilot-cmp").config,
		},
	},
}

return completion