return function()
	local null_ls = require("null-ls")
	local disabled_worksapces = require("core.settings").format_disabled_dirs
	local format_on_save = require("core.settings").format_on_save

	-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins
	local b = null_ls.builtins

	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

	local with_diagnostics_code = function(builtin)
		return builtin.with({
			diagnostics_format = "#{m} [#{c}]",
		})
	end

	local sources = {
		-- formatting

		b.formatting.black.with({ extra_args = { "--fast" } }),
		b.formatting.prettierd.with({
			extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
		}),
		b.formatting.shfmt,
		b.formatting.stylua,
		b.formatting.markdownlint,
		b.formatting.clang_format.with({
			command = "clang-format -style='{BasedOnStyle: LLVM, IndentWidth: 4}'",
		}),
		b.formatting.rustfmt,
		b.formatting.eslint_d,

		-- diagnostics
		with_diagnostics_code(b.diagnostics.shellcheck),
		b.diagnostics.markdownlint.with({
			extra_args = { "--disable MD033" },
		}),
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
							-- filter = function()
							--     return client.name == "null-ls"
							-- end,
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

	-- NOTE: if you want to use local executables.
	-- local sources = {
	--     null_ls.builtins.formatting.prettier.with({
	--         command = "/path/to/prettier",
	--     }),
	-- }
end
