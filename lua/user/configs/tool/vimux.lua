return function()
	vim.g.VimuxHeight = "20"
	vim.cmd([[let g:VimuxCloseOnExit = 1]])
	vim.cmd([[command Runpythongnome AsyncRun -mode=term -pos=gnome python "$(VIM_FILEPATH)"]])
end
