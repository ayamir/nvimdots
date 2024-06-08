local null_ls = require("null-ls")

local bibtex_tidy = {
	name = "bibtex-tidy",
	method = null_ls.methods.FORMATTING,
	filetypes = { "bib" },
	generator = null_ls.formatter({
		command = "bibtex-tidy",
		args = { "--curly", "-" },
		to_stdin = true,
	}),
}
return bibtex_tidy
