return function()
	require("modules.utils").load_plugin("go", {
		lsp_keymaps = false,
		dap_debug_keymap = false,
		icons = false,
		gofmt = "gopls",
		goimports = "gopls",
		lsp_gofumpt = "true",
		lsp_inlay_hints = { enable = false },
		run_in_floaterm = true,
		trouble = true,
		lsp_codelens = false,
		lsp_cfg = require("modules.configs.completion.servers.gopls"),
	})
end
