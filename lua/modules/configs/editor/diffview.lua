return function()
	require("diffview").setup({
		view = {
			merge_tool = {
				disable_diagnostics = true,
			},
		},
	})
end
