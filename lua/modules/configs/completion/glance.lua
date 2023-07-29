return function()
	require("glance").setup({
		border = {
			enable = true, -- Show window borders. Only horizontal borders allowed
			top_char = "-",
			bottom_char = "-",
		},
		preview_win_opts = { -- Configure preview window options
			cursorline = true,
			number = true,
			wrap = false,
		},
		-- your configuration
	})
end
