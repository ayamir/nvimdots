return function()
	require("sidebar-nvim").setup({
		sections = {
			"datetime",
			"git",
			-- "symbols",
			"todos",
			"files",
			"buffers",
		},
		symbols = {
			icon = "ƒ",
		},
		initial_width = 30,
	})
end
