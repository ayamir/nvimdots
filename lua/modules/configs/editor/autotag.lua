local M = {}

M["opts"] = function()
	return {
		filetypes = {
			"html",
			"javascript",
			"javascriptreact",
			"typescriptreact",
			"vue",
			"xml",
		},
	}
end

M["config"] = function(_, opts)
	require("nvim-ts-autotag").setup(opts)
end

return M