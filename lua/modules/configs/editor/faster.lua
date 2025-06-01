return function()
	require("faster").setup({
		behaviours = {
			bigfile = {
				on = true,
				features_disabled = {
					"filetype",
					"indent_blankline",
					"lsp",
					"matchparen",
					"syntax",
					"treesitter",
					"vimopts",
				},
				filesize = 2, -- size of the file in MiB
			},
			fastmacro = {
				on = true,
				features_disabled = { "lualine" },
			},
		},
		features = {
			-- Neovim filetype plugin
			-- https://neovim.io/doc/user/filetype.html
			filetype = {
				on = true,
				defer = true,
			},
			-- Indent Blankline
			-- https://github.com/lukas-reineke/indent-blankline.nvim
			indent_blankline = {
				on = true,
				defer = false,
			},
			-- Neovim LSP
			-- https://neovim.io/doc/user/lsp.html
			lsp = {
				on = true,
				defer = false,
			},
			-- Lualine
			-- https://github.com/nvim-lualine/lualine.nvim
			lualine = {
				on = true,
				defer = false,
			},
			-- Neovim Pi_paren plugin
			-- https://neovim.io/doc/user/pi_paren.html
			matchparen = {
				on = true,
				defer = false,
			},
			-- Neovim syntax
			-- https://neovim.io/doc/user/syntax.html
			syntax = {
				on = true,
				defer = true,
			},
			-- Neovim treesitter
			-- https://neovim.io/doc/user/treesitter.html
			treesitter = {
				on = true,
				defer = false,
			},
			-- Neovim options that affect speed when big file is opened:
			-- swapfile, foldmethod, undolevels, undoreload, list
			vimopts = {
				on = true,
				defer = false,
			},
		},
	})
end
