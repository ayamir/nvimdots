return function()
	local null_ls = require("null-ls")
	local mason_null_ls = require("mason-null-ls")

	local sources = {
		null_ls.builtins.diagnostics.vint,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.diagnostics.editorconfig_checker,
		null_ls.builtins.formatting.clang_format.with({
			filetypes = { "c", "cpp" },
			extra_args = require("completion.null-ls.formatters.clang_format"),
		}),
		null_ls.builtins.formatting.black.with({
			extra_args = { "--fast" },
		}),
		null_ls.builtins.formatting.prettier.with({
			filetypes = {
				"vue",
				"typescript",
				"javascript",
				"typescriptreact",
				"javascriptreact",
				"yaml",
				"html",
				"css",
				"scss",
				"sh",
				"markdown",
			},
		}),
	}
	null_ls.setup({
		border = "rounded",
		debug = false,
		log_level = "warn",
		update_in_insert = false,
		sources = sources,
	})

	mason_null_ls.setup({
		ensure_installed = require("core.settings").null_ls_deps,
		automatic_installation = false,
		automatic_setup = false,
	})

	require("completion.formatting").configure_format_on_save()
end
