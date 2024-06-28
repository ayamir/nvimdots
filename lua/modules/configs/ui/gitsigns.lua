return function()
	local mapping = require("keymap.ui")
	require("modules.utils").load_plugin("gitsigns", {
		signs = {
			add = {
				text = "│",
			},
			change = {
				text = "│",
			},
			delete = {
				text = "_",
			},
			topdelete = {
				text = "‾",
			},
			changedelete = {
				text = "~",
			},
		},
		on_attach = mapping.gitsigns,
		watch_gitdir = { interval = 1000, follow_files = true },
		current_line_blame = true,
		current_line_blame_opts = { delay = 1000, virtual_text_pos = "eol" },
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil, -- Use default
		word_diff = false,
		diff_opts = { internal = true },
	})
end
