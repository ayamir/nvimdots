return function()
	vim.api.nvim_set_hl(
		0,
		"CleverChar",
		{ underline = true, bold = true, fg = "Orange", bg = "NONE", ctermfg = "Red", ctermbg = "NONE" }
	)
	vim.g.clever_f_mark_char_color = "CleverChar"
	vim.g.clever_f_mark_direct_color = "CleverChar"
	vim.g.clever_f_mark_direct = true
	vim.g.clever_f_timeout_ms = 1500
end
