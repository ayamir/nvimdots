return function()
	local btn = require("null-ls").builtins

	require("mason-null-ls").setup({
		ensure_installed = require("core.settings").null_ls,
		automatic_installation = true,
		automatic_setup = true,
	})

	require("null-ls").setup({
		debug = false,
		update_in_insert = false,
		diagnostics_format = "[#{c}] #{m} (#{s})",
		-- NOTE: Users don't need to specify null-ls sources if using only default config.
		-- "mason-null-ls" will auto-setup for users.
		sources = {
			-- formatting
			btn.formatting.black.with({ extra_args = { "--fast" } }),
			btn.formatting.markdownlint,

			-- diagnostics
			btn.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
			btn.diagnostics.markdownlint.with({ extra_args = { "--disable MD033" } }),
		},
	})

	require("mason-null-ls").setup_handlers()

	require("completion.formatting").configure_format_on_save()
end
