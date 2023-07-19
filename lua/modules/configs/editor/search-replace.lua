return function()
	require("search-replace").setup({
		-- optionally override defaults
		default_replace_single_buffer_options = "gcI",
		default_replace_multi_buffer_options = "egcI",
	})
end
