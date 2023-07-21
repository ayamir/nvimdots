return function()
	vim.g.vimtex_enabled = true
	vim.g.tex_flavor = "xelatex --shell-escape"
	vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"
	vim.g.vimtex_quickfix_mode = false
	vim.g.vimtex_quickfix_autoclose_after_keystrokes = 3
	vim.g.vimtex_complete_enabled = true
	vim.g.vimtex_compiler_progname = "nvr"
	vim.g.vimtex_compiler_method = "latexmk"
	vim.g.vimtex_view_general_automatic = false

	local global = require("core.global")

	if global.is_wsl then
		vim.g.vimtex_view_method = "sioyek"
		-- NOTE: Remember to `ln -s /path/in/windows/sioyek.exe /usr/local/bin/sioyek.exe`
		vim.g.vimtex_view_sioyek_exe = "sioyek.exe"
		vim.g.vimtex_callback_progpath = "wsl nvim"
	end
end
