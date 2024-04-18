return function()
	require("modules.utils").load_plugin("go", {
		-- By default, we've turned off these options to prevent clashes with our gopls config
		icons = false,
		diagnostic = false,
		lsp_cfg = false,
		lsp_gofumpt = false,
		lsp_keymaps = false,
		lsp_codelens = false,
		lsp_document_formatting = false,
		lsp_inlay_hints = { enable = false },
		-- DAP-related settings are also turned off here for the same reason
		dap_debug = false,
		dap_debug_keymap = false,
		textobjects = false,
		-- Miscellaneous options to seamlessly integrate with other plugins
		trouble = true,
		luasnip = false,
		run_in_floaterm = false,
	})
end
