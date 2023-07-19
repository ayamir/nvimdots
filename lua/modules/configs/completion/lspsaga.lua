return function()
	require("modules.utils").gen_lspkind_hl()

	require("lspsaga").setup({
		ui = {
			-- currently only round theme
			theme = "round",
			-- border type can be single,double,rounded,solid,shadow.
			border = "rounded",
			winblend = 0,
			expand = "",
			collaspe = "",
			preview = " ",
			code_action = "💡",
			diagnostic = "🐞",
			incoming = " 󰏷 ",
			outgoing = " 󰏻 ",
			colors = {
				--float window normal bakcground color
				-- normal_bg = "#1d1536",
				normal_bg = "None",
				--title background color
				title_bg = "#afd700",
				red = "#e95678",
				magenta = "#b33076",
				orange = "#FF8700",
				yellow = "#f7bb3b",
				green = "#afd700",
				cyan = "#36d0e0",
				blue = "#61afef",
				purple = "#CBA6F7",
				white = "#d1d4cf",
				black = "#1c1c19",
			},
			kind = {},
		},
		preview = {
			lines_above = 0,
			lines_below = 10,
		},
		scroll_preview = {
			scroll_down = "<C-f>",
			scroll_up = "<C-b>",
		},
		request_timeout = 4000,
		symbol_in_winbar = {
			enable = false,
			separator = " ",
			hide_keyword = true,
			show_file = true,
			folder_level = 2,
		},
		finder = {
			max_height = 0.3,
			position = "above",
			keys = {
				jump_to = "p",
				edit = { "o", "<CR>" },
				vsplit = "s",
				split = "i",
				tabe = "t",
				quit = { "q", "<ESC>" },
				close_in_preview = "q",
			},
		},
		definition = {
			edit = "<C-c>o",
			vsplit = "<C-c>v",
			split = "<C-c>i",
			tabe = "<C-c>t",
			quit = "q",
			close = "<Esc>",
		},
		code_action = {
			num_shortcut = true,
			keys = {
				quit = "q",
				exec = "<CR>",
			},
		},
		lightbulb = {
			enable = true,
			enable_in_insert = true,
			sign = false,
			sign_priority = 40,
			virtual_text = false,
		},
		diagnostic = {
			twice_into = false,
			show_code_action = true,
			show_source = true,
			keys = {
				exec_action = "o",
				quit = "q",
			},
		},
		rename = {
			-- quit = "<C-c>",
			quit = "<ESC>",
			exec = "<CR>",
			in_select = true,
		},
		outline = {
			win_position = "right",
			win_with = "",
			win_width = 30,
			show_detail = true,
			auto_preview = false,
			auto_refresh = true,
			auto_close = false,
			custom_sort = nil,
			focus = false,
			keys = {
				jump = "<CR>",
				expand_collapse = "o",
				quit = "q",
			},
		},
		callhierarchy = {
			show_detail = false,
			keys = {
				edit = "e",
				vsplit = "s",
				split = "i",
				tabe = "t",
				jump = "p",
				quit = "q",
				expand_collaspe = "u",
			},
		},
	})
end
