augroup user_plugin_cursorword
	autocmd!
	autocmd FileType NvimTree,lspsagafinder,dashboard let b:cursorword=0
	autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif
	autocmd InsertEnter * let b:cursorword=0
	autocmd InsertLeave * let b:cursorword=1
augroup END
