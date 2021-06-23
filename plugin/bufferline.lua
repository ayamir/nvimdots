require "bufferline".setup {
	options = {
		number = "none",
		number_style = "superscript",
		offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "center", padding = 1}},
		buffer_close_icon = "",
		modified_icon = "",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",
		max_name_length = 14,
		max_prefix_length = 13,
		tab_size = 20,
		show_tab_indicators = true,
		diagnostics = "nvim_lsp",
		enforce_regular_tabs = false,
		view = "multiwindow",
		show_buffer_close_icons = true,
		always_show_bufferline = false,
		separator_style = "thin",
		mappings = "true",
		custom_filter = function(buf_number)
			if vim.fn.bufname(buf_number) ~= "dashboard" then
				return true
			end
		end,
	}
}
