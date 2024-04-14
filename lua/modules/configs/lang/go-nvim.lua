return function()
	require("modules.utils").load_plugin("go", {
		-- disable lsp related keymap of plugin itself
		lsp_keymaps = false,
		-- disable it to avoid conflicts of unified dap configuration
		dap_debug = false,
		dap_debug_keymap = false,
		icons = false,
		gofmt = "gopls",
		goimports = "gopls",
		-- set gofumpt as default formatter of gopls
		lsp_gofumpt = true,
		lsp_document_formatting = true,
		lsp_codelens = false,
		-- disable inlay hints by default
		lsp_inlay_hints = { enable = false },
		-- show failed test info in trouble window
		trouble = true,
		-- show passed test info in notify message
		run_in_floaterm = false,
		-- gopls config
		lsp_cfg = true,
	})
end
