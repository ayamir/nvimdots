return function()
	require("modules.utils").load_plugin("treesitter-context", {
		enable = true,
		line_numbers = true,
		max_lines = 3,
		min_window_height = 0,
		multiline_threshold = 20,
		trim_scope = "outer",
		mode = "cursor",
		-- Ensure compatibility with Glance's preview window
		zindex = 50,
	})
end
