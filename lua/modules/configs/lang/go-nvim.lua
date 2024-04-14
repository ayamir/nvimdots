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
		-- set gopls to format
		lsp_document_formatting = true,
		-- set gofumpt as default formatter of gopls
		lsp_gofumpt = true,
		-- disable codelens by default
		lsp_codelens = false,
		-- disable inlay hints by default
		lsp_inlay_hints = { enable = false },
		-- show failed test info in trouble window
		trouble = true,
		-- show passed test info in notify message
		run_in_floaterm = false,
		-- use default gopls config provided by go.nvim
		lsp_cfg = true,
	})
end
