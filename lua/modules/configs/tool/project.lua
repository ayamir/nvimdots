return function()
	require("modules.utils").load_plugin("project", {
		manual_mode = false,
		lsp = {
			enabled = true,
			ignore = { "null-ls", "copilot" },
			use_pattern_matching = false,
			no_fallback = false,
		},
		patterns = {
			".bzr",
			".csproj",
			".git",
			".github",
			".hg",
			".nvim.lua",
			".pre-commit-config.yaml",
			".pre-commit-config.yml",
			".sln",
			".svn",
			"Makefile",
			"Pipfile",
			"_darcs",
			"package.json",
			"pyproject.toml",
		},
		exclude_dirs = {},
		show_hidden = false,
		silent_chdir = true,
		scope_chdir = "global",
		datapath = vim.fn.stdpath("data"),
	})
end
