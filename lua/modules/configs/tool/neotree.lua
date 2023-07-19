return function()
	require("neo-tree").setup({
		close_if_last_window = true,
		enable_diagnostics = false,
		popup_border_style = "rounded",
		update_cwd = true,
		enable_git_status = true,
		default_component_configs = {
			indent = {
				indent_size = 2,
				padding = 2,
				with_markers = true,
				indent_marker = "│",
				last_indent_marker = "└",
				highlight = "NeoTreeIndentMarker",
				with_expanders = true,
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},
			git_status = {
				symbols = {
					added = "",
					deleted = "",
					modified = "★",
					renamed = "➜",
					untracked = "☆",
					ignored = "◌",
					unstaged = "✗",
					staged = "✓",
					conflict = "",
				},
			},
			icon = {
				folder_closed = "󰉋",
				folder_open = "󰝰",
				folder_empty = "",
				default = "",
			},
			name = {
				trailing_slash = false,
				use_git_status_colors = true,
			},
		},
		window = {
			position = "left",
			width = 28,
			mappings = {
				["<2-LeftMouse>"] = "open_with_window_picker",
				["<cr>"] = "open_with_window_picker",
				["o"] = "open_with_window_picker",
				["/"] = "",
				-- ["h"] = "toggle_hidden",
				-- ["H"] = "",
			},
		},
	})
end
