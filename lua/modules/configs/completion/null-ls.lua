return function()
	local null_ls = require("null-ls")
	local methods = require("null-ls.methods")
	local helpers = require("null-ls.helpers")

	local mason_null_ls = require("mason-null-ls")
	local btns = null_ls.builtins

	local is_executable = function(cmd_name, cond)
		local u = require("null-ls.utils")
		return function()
			local ie = u.is_executable(cmd_name)
			if cond == false then
				ie = not ie
			end
			return ie
		end
	end

	local function ruff_fix()
		return helpers.make_builtin({
			name = "ruff",
			meta = {
				url = "https://github.com/charliermarsh/ruff/",
				description = "An extremely fast Python linter, written in Rust.",
			},
			method = methods.internal.FORMATTING,
			filetypes = { "python" },
			generator_opts = {
				command = "ruff",
				args = {
					"--fix",
					"-e",
					"-n",
					"--stdin-filename",
					"$FILENAME",
					"--unfixable F401",
					-- "--unfixable I001",
					"-",
				},
				to_stdin = true,
			},
			factory = helpers.formatter_factory,
		})
	end

	-- Please set additional flags for the supported servers here
	-- Don't specify any config here if you are using the default one.
	local sources = {
		btns.formatting.clang_format.with({
			filetypes = { "c", "cpp" },
			extra_args = require("completion.formatters.clang_format"),
		}),
		btns.formatting.prettier.with({
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
		btns.formatting.rustfmt,
		-- Markdown
		btns.diagnostics.markdownlint.with({
			extra_args = { "--disable=line_length" },
			condition = is_executable("markdownlint"),
		}),
		btns.diagnostics.alex,

		-- Python
		btns.formatting.black.with({
			extra_args = { "--line-length=80" },
			condition = is_executable("black"),
		}),
		-- null_ls.builtins.diagnostics.vulture.with({
		--     condition = is_executable("black"),
		-- }),
		ruff_fix(),
		btns.diagnostics.ruff.with({
			extra_args = {
				"--ignore=E501",
				"--ignore=E402",
				"--ignore=B905",
				"--ignore=N803",
				"--ignore=N802",
				"--ignore=N806",
				"--select=I",
				"--select=A",
				"--select=ANN",
				"--select=B",
				-- "--select=D",
				"--select=N",
				-- "--select=PD",
				"--select=C90",
				"--ignore=ANN101",
				"--ignore=ANN401",
				"--ignore=N812",
				"--ignore=F405",
				"--ignore=F401",
				"--ignore=I001",
				-- "--extend-ignore=ANN",
			},
			condition = is_executable("ruff"),
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
		automatic_setup = true,
		handlers = {},
	})

	require("completion.formatting").configure_format_on_save()
end
