return function()
	-- do not update $HOME on Windows since I set it manually
	if vim.fn.has("win32") == 1 then
		vim.g.R_set_home_env = 0
	end

	-- disable debugging support,

	vim.g.R_debug = 1
	-- do not align function arguments
	vim.g.r_indent_align_args = 0
	-- use two backticks to trigger the Rmarkdown chunk completion
	vim.g.R_rmdchunk = "``"
	-- use <Alt>- to insert assignment
	vim.g.R_assign_map = "<M-->"
	-- show hidden objects in object browser
	vim.g.R_objbr_allnames = 1
	-- show comments when sourced
	vim.g.R_commented_lines = 1
	-- use the same working directory as Vim
	vim.g.R_nvim_wd = 1
	-- highlight chunk header as R code
	vim.g.rmd_syn_hl_chunk = 1
	-- only highlight functions when followed by a parenthesis
	vim.g.r_syntax_fun_pattern = 1
	-- set encoding to UTF-8 when sourcing code
	vim.g.R_source_args = 'spaced = TRUE, encoding = "UTF-8"'
	-- number of columns to be offset when calculating R terminal width
	vim.g.R_setwidth = -7
	vim.g.rmd_fenced_languages = { "r" }

	-- auto quit R when close Vim
	vim.cmd([[
                autocmd VimLeave * if exists("g:SendCmdToR") && string(g:SendCmdToR) != "function('SendCmdToR_fake')" | call RQuit("nosave") | endif
            ]])
end
