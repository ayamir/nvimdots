return function()
	vim.api.nvim_create_augroup("TableModeSetTableCorner", { clear = true })
	vim.api.nvim_create_autocmd("Filetype", {
		pattern = { "markdown", "org" },
		group = "TableModeSetTableCorner",
		command = 'let b:table_mode_corner = "|"',
	})

	-- vim.api.nvim_create_augroup("TableModeFormatOnSave", { clear = true })
	-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	-- 	pattern = { "*.txt", "*.md" },
	-- 	group = "TableModeFormatOnSave",
	-- 	callback = function()
	-- 		if vim.api.nvim_get_current_line():match("^%s*|") then
	-- 			vim.cmd("silent! TableModeRealign")
	-- 		end
	-- 	end,
	-- })
	vim.cmd([[
function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'
]])
end
