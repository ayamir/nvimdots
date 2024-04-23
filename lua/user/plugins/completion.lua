local completion = {}

completion["iurimateus/luasnip-latex-snippets.nvim"] = {
	lazy = true,
	ft = { "tex", "bib", "markdown" },
	config = require("configs.completion.luasnip-latex-snippets"),
}

return completion
