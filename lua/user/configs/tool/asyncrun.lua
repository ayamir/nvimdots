return function()
	vim.g.asyncrun_open = 10
	vim.api.nvim_create_user_command("Rungnome", function(opts)
		vim.cmd('AsyncRun -mode=term -pos=gnome python "$(VIM_FILEPATH)"')
	end, {})
end
