return function()
	require("modules.utils").load_plugin("nvim-ts-autotag", {
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
