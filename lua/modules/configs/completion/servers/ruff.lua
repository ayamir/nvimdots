-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/ruff.lua
return {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },

	-- the following are added by nvimdots
	settings = {
		init_options = {
			settings = {
				lint = {
					select = {
						-- enable: pycodestyle
						"E",
						-- enable: pyflakes
						"F",
					},
					extendSelect = {
						-- enable: isort
						"I",
					},
					-- the same line length as black
					lineLength = 88,
				},
			},
		},
	},
}
