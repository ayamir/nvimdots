return function()
	require("modules.utils").load_plugin("neoscroll", {
		hide_cursor = true,
		stop_eof = true,
		use_local_scrolloff = false,
		respect_scrolloff = false,
		cursor_scrolls_alone = true,
		-- All these keys will be mapped to their corresponding default scrolling animation
		mappings = {
			"<C-u>",
			"<C-d>",
			"<C-b>",
			"<C-f>",
			"<C-y>",
			"<C-e>",
			"zt",
			"zz",
			"zb",
		},
	})
end
