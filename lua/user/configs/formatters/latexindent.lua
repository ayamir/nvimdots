local null_ls = require("null-ls")
local latexindent = {
	name = "latexindent",
	method = null_ls.methods.FORMATTING,
	filetypes = { "tex" },
	generator = null_ls.formatter({ command = "latexindent", args = { "-g=/dev/null", "-" }, to_stdin = true }),
}
-- null_ls.register(latexindent)
return latexindent
