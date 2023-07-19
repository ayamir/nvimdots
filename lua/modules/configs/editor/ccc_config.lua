return function()
	require("ccc").setup({
		default_color = "#000000", -- The default color used when a color cannot be picked. It must be HEX format.
		bar_char = "■", -- The character used for the sliders.
		point_char = "◇", -- The character used for the cursor point on the sliders.
		point_color = "", -- The color of the cursor point on the sliders. It must be HEX format. If it is empty string (""), like the other part of the sliders, it is dynamically highlighted.
		bar_len = 30, -- The length of the slider (not byte length). This value number of bar_chars form a slider.
		win_opts = { -- The options passed to the |nvim_open_win|. 'width' and 'height' cannot be specified
			relative = "cursor",
			row = 1,
			col = 1,
			style = "minimal",
			border = "rounded",
		},
		auto_close = true, -- If true, then leaving the ccc UI will automatically close the window.
		-- preserve = true, -- Whether to preserve the colors when the UI is closed. If this is true, you can start where you left off last time.
		save_on_quit = true, -- Whether to add colors to prev_colors when quit (ccc-action-quit).
		alpha_show = "auto", -- This option determines whether the alpha slider is displayed when the UI is opened. "show" and "hide" mean as they are. "auto" makes the slider appear only when the alpha value can be picked up.
		highlight_mode = "bg", -- Option to highlight text foreground or background. It is used to output_line and highlighter.
		highlighter = { -- These are settings for CccHighlighter.
			auto_enable = true, -- Whether to enable automatically on BufEnter.
			max_byte = 100 * 1024, -- The maximum buffer size for which highlight is enabled by
			filetypes = { "lua", "html", "css" }, -- File types for which highlighting is enabled. An empty table means all file types.
			excludes = {}, -- Used only when ccc-option-highlighter-filetypes is empty table. You can specify file types to be excludes.
			lsp = true, -- If true, highlight using textDocument/documentColor. If LS with the color provider is not attached to a buffer, it falls back to highlight with pickers.
		},
		recognize = { -- These are settings for recognize color format.
			input = true, -- If true, doing |:CccPick|, it recognizes the color format and automatically adjusts the input to it.
			output = true, -- If true, doing |:CccPick|, it recognizes the color format and automatically adjusts the output to it.
		},
		disable_default_mappings = false, -- If true, all default mappings are disabled.
	})
end
