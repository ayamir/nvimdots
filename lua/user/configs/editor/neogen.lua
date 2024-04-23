return function()
	require("neogen").setup({
		snippet_engine = "luasnip",
		input_after_comment = true,
		languages = {
			python = {
				template = {
					annotation_convention = "numpydoc",
				},
			},
		},
	})
end
