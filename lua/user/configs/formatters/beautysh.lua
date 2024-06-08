local null_ls = require("null-ls")
local beautysh = {
	name = "beautysh",
	method = null_ls.methods.FORMATTING,
	filetypes = { "bash", "csh", "ksh", "sh", "zsh" },
	generator = null_ls.formatter({ command = "beautysh", args = { "$FILENAME" }, to_temp_file = true }),
}
return beautysh
