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
			buffers = {
				follow_current_file = {
					enabled = true, -- This will find and focus the file in the active buffer every time
					--              -- the current file is changed while the tree is open.
					leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
				},
				group_empty_dirs = true, -- when true, empty folders will be grouped together
				show_unloaded = true,
				window = {
					mappings = {
						["bd"] = "buffer_delete",
						["<bs>"] = "navigate_up",
						["."] = "set_root",
					},
				},
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
