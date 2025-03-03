return function()
	require("modules.utils").load_plugin("smart-splits", {
		-- The default number of lines/columns to resize by at a time
		default_amount = 3,
		-- Ignored filetypes (only while resizing)
		ignored_filetypes = {
			"NvimTree",
		},
		-- Ignored buffer types (only while resizing)
		ignored_buftypes = {
			"nofile",
			"quickfix",
			"prompt",
		},
	})
end
