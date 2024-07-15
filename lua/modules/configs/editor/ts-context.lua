return function()
	require("modules.utils").load_plugin("treesitter-context", {
		enable = true,
		max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
		min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
		line_numbers = true,
		multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
		trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
		mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
		zindex = 50, -- Ensure compatibility with Glance's preview window
	})
end
