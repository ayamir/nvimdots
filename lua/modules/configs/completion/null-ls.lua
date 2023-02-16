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
		sources = {
			-- formatting
			btn.formatting.black.with({ extra_args = { "--fast" } }),
			btn.formatting.clang_format,
			btn.formatting.eslint_d,
			btn.formatting.jq,
			btn.formatting.markdownlint,
			btn.formatting.prettierd,
			btn.formatting.rustfmt,
			btn.formatting.shfmt,
			btn.formatting.stylua,

			-- diagnostics
			btn.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
			btn.diagnostics.markdownlint.with({ extra_args = { "--disable MD033" } }),
		},
	})

	require("mason-null-ls").setup_handlers()

	require("completion.formatting").configure_format_on_save()
end
