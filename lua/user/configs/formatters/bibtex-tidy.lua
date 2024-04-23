local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING

return h.make_builtin({
	name = "bibtex-tidy",
	meta = {
		url = "https://github.com/FlamingTempura/bibtex-tidy",
		description = "Tidy bibtex files.",
		notes = {},
	},
	method = FORMATTING,
	filetypes = { "bib" },
	generator_opts = {
		command = "bibtex-tidy",
		args = { "--curly", "-" },
		to_stdin = true,
	},
	factory = h.formatter_factory,
})
