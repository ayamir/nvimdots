return function()
	require("modules.utils").load_plugin("smart-splits", {
		-- The default number of lines/columns to resize by at a time
		default_amount = 3,
		ignored_buftypes = {
			"nofile",
			"quickfix",
			"prompt",
		},
		ignored_filetypes = { "NvimTree" },
	})
end
