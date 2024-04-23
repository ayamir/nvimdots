local null_ls = require("null-ls")
local btns = null_ls.builtins

return {
	sources = {
		btns.formatting.clang_format.with({
			filetypes = { "c", "cpp" },
			extra_args = { "-style={BasedOnStyle: LLVM, IndentWidth: 2}" },
		}),
		btns.formatting.black.with({
			extra_args = {},
		}),
		-- btns.formatting.yapf.with({
		-- 	extra_args = {
		-- 		"--style={based_on_style: facebook, indent_width: 4}",
		-- 	},
		-- }),
		require("user.configs.formatters.bibtex-tidy"),
		require("user.configs.formatters.xmlformat"),
		require("user.configs.formatters.latexindent"),
	},
}
