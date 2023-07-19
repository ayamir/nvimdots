local lang = {}

lang["simrat39/rust-tools.nvim"] = {
	lazy = true,
	ft = "rust",
	config = require("lang.rust-tools"),
	dependencies = { "nvim-lua/plenary.nvim" },
}
lang["Saecki/crates.nvim"] = {
	lazy = true,
	event = "BufReadPost Cargo.toml",
	config = require("lang.crates"),
	dependencies = { "nvim-lua/plenary.nvim" },
}
lang["iamcco/markdown-preview.nvim"] = {
	lazy = true,
	ft = "markdown",
	build = ":call mkdp#util#install()",
}
lang["chrisbra/csv.vim"] = {
	lazy = true,
	ft = "csv",
}
lang["lervag/vimtex"] = {
	lazy = true,
	ft = { "markdown", "tex", "ipynb", "org" },
}
lang["KeitaNakamura/tex-conceal.vim"] = {
	lazy = true,
	ft = { "markdown", "tex", "ipynb", "org" },
}
lang["jbyuki/nabla.nvim"] = {
	lazy = true,
	ft = { "markdown", "tex", "ipynb", "org", "lua", "python" },
}
lang["ellisonleao/glow.nvim"] = {
	lazy = true,
	ft = { "markdown" },
	config = function()
		require("glow").setup({
			border = "rounded",
		})
	end,
}
lang["nvim-orgmode/orgmode"] = {
	lazy = true,
	ft = { "org", "orgmode" },
	config = function()
		require("orgmode").setup_ts_grammar()
		require("orgmode").setup({
			org_highlight_latex_and_related = "entities",
			org_agenda_files = { "~/Dropbox/org/*" },
		})
	end,
	dependencies = {
		{
			"akinsho/org-bullets.nvim",
			config = function()
				require("org-bullets").setup({
					concealcursor = true,
					symbols = {
						headlines = { "◉", "○", "✸", "✿" },
						checkboxes = {
							cancelled = { "", "OrgCancelled" },
							todo = { "-", "OrgTODO" },
							done = { "✓", "OrgDone" },
						},
					},
				})
			end,
		},
	},
}
lang["lukas-reineke/headlines.nvim"] = {
	lazy = true,
	ft = { "markdown", "org" },
	config = require("lang.headlines"),
}
lang["dhruvasagar/vim-table-mode"] = {
	lazy = true,
	cmd = { "TableModeEnable", "TableModelToggle" },
	ft = { "markdown", "tex", "ipynb", "org" },
	event = { "BufAdd", "InsertEnter" },
    config = require("lang.vim_table_mode")
}
lang["mtdl9/vim-log-highlighting"] = {
	lazy = true,
	ft = {
		"text",
		"txt",
		"log",
	},
}
lang["AckslD/swenv.nvim"] = {
	lazy = true,
	ft = "python",
	config = require("lang.swenv"),
}
lang["folke/neodev.nvim"] = {
	lazy = true,
	ft = "lua",
	config = require("lang.neodev_config"),
}

return lang
