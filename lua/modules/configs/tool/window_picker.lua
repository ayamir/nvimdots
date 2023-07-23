return function()
	require("window-picker").setup({
		-- hint = "floating-big-letter",
		autoselect_one = true,
		include_current = false,
		filter_rules = {
			bo = {
				filetype = { "neo-tree-popup", "quickfix", "VistaNvim" },
				buftype = { "terminal", "quickfix" },
			},
		},
	})
end
