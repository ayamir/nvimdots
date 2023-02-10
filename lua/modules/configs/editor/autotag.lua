return function()
	require("nvim-ts-autotag").setup({
		filetypes = {
			"html",
			"javascript",
			"javascriptreact",
			"typescriptreact",
			"vue",
			"xml",
		},
	})
end
