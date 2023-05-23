return function()
	require("go").setup({
		lsp_keymaps = false,
		dap_debug_keymap = false,
		icons = false,
		gofmt = "gopls",
		goimport = "gopls",
		lsp_gofumpt = "true",
		lsp_inlay_hints = { enable = false },
		run_in_floaterm = true,
		trouble = true,
		lsp_cfg = {
			flags = { debounce_text_changes = 500 },
			cmd = { "gopls", "-remote=auto" },
			settings = {
				gopls = {
					usePlaceholders = true,
					analyses = {
						nilness = true,
						shadow = true,
						unusedparams = true,
						unusewrites = true,
					},
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				},
			},
		},
	})
end
