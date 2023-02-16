return function()
	local null_ls = require("null-ls")
	local btn = null_ls.builtins -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins
	local disabled_worksapces = require("core.settings").format_disabled_dirs
	local format_on_save = require("core.settings").format_on_save

	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

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
		on_attach = function(client, bufnr)
			local cwd = vim.fn.getcwd()
			for i = 1, #disabled_worksapces do
				if cwd.find(cwd, disabled_worksapces[i]) ~= nil then
					return
				end
			end
			if client.supports_method("textDocument/formatting") and format_on_save then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({
							bufnr = bufnr,
							name = "null-ls",
						})
						vim.notify(
							string.format("Format successfully with [%s]!", client.name),
							vim.log.levels.INFO,
							{ title = "LspFormat" }
						)
					end,
				})
			end
		end,
	})

	require("mason-null-ls").setup({
		ensure_installed = nil,
		automatic_installation = true,
		automatic_setup = false,
	})
end
