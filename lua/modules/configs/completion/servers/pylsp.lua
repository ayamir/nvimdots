-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/pylsp.lua
return {
	cmd = { "pylsp" },
	filetypes = { "python" },
	settings = {
		pylsp = {
			plugins = {
				-- Lint
				ruff = {
					enabled = true,
					config = "$HOME/.config/python/pyproject.toml",
				},
				flake8 = { enabled = false },
				pyflakes = { enabled = false },
				pycodestyle = { enabled = false },
                pydocstyle = {
                    enabled = true,
                    convention = "google",
                    addIgnore = {"D105","D107"},
                },
				pylsp_mypy = {
					enabled = true,
					report_progress = true,
					live_mode = false,
				},
				mccabe = { enabled = false },
				pylint = {
					enabled = true,
					executable = "pylint",
					args = {
						"--rcfile $HOME/.config/python/pylintrc",
					},
				},

				-- Code refactor
				rope = { enabled = true },

				-- Formatting
				black = { enabled = true },
				pyls_isort = { enabled = false },
				autopep8 = { enabled = false },
				yapf = { enabled = false },
			},
		},
	},
}
