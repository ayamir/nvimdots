return function()
	local formatting = require("completion.formatting")

	local null_ls = require("null-ls")
	local btn = null_ls.builtins -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins

	local sources = {
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
	}

	null_ls.setup({
		debug = false,
		update_in_insert = false,
		diagnostics_format = "[#{c}] #{m} (#{s})",
		sources = sources,
	})

	require("mason-null-ls").setup({
		ensure_installed = nil,
		automatic_installation = true,
		automatic_setup = false,
	})

	formatting.configure_format_on_save()
end
