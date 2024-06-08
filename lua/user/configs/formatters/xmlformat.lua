local null_ls = require("null-ls")
local xmlformat = {
	name = "xmlformat",
	method = null_ls.methods.FORMATTING,
	filetypes = { "xml" },
	generator = null_ls.formatter({
		command = "xmlformat",
		args = { "-" },
		to_stdin = true,
	}),
}
return xmlformat
