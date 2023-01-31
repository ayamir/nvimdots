local completion = {}

completion["neovim/nvim-lspconfig"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = function()
		require("modules.completion.lsp")
	end,
	dependencies = {
		{ "creativenull/efmls-configs-nvim" },
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			config = function()
				require("modules.completion.masoninstall")
			end,
		},
		{
			"glepnir/lspsaga.nvim",
			config = function()
				require("modules.completion.saga")
			end,
		},
		{ "ray-x/lsp_signature.nvim" },
	},
}
completion["hrsh7th/nvim-cmp"] = {
	event = "InsertEnter",
	config = function()
		require("modules.completion.Cmp")
	end,
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			dependencies = { "rafamadriz/friendly-snippets" },
			config = function()
				require("modules.completion.Luasnip")
			end,
		},
		{ "onsails/lspkind.nvim" },
		{ "lukas-reineke/cmp-under-comparator" },
		{ "saadparwaiz1/cmp_luasnip" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-nvim-lua" },
		{ "andersevenrud/cmp-tmux" },
		{ "hrsh7th/cmp-path" },
		{ "f3fora/cmp-spell" },
		{ "hrsh7th/cmp-buffer" },
		{ "kdheepak/cmp-latex-symbols" },
		{
			"windwp/nvim-autopairs",
			config = function()
				require("modules.completion.autopairs")
			end,
		},
		-- { "tzachar/cmp-tabnine", build = "./install.sh", config = conf.tabnine },
	},
}
completion["zbirenbaum/copilot.lua"] = {
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("modules.completion.copilot")
	end,
	dependencies = {
		{
			"zbirenbaum/copilot-cmp",
			config = function()
				require("copilot_cmp").setup({})
			end,
		},
	},
}

return completion
