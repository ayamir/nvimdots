return {
	settings = {
		pylsp = {
			plugins = {
				-- enabled tools
				-- lint related
				ruff = {
					enabled = true,
					extendSelect = { "I" },
				},
				-- refactor related
				rope = { enabled = true },
				-- format related
				black = { enabled = true },
				pyls_isort = { enabled = true },

				-- disabled tools
				-- lint related
				flake8 = { enabled = false },
				pyflakes = { enabled = false },
				pycodestyle = { enabled = false },
				-- format related
				autopep8 = { enabled = false },
				yapf = { enabled = false },
			},
		},
	},
}
