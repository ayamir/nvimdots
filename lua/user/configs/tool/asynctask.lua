return function()
	vim.g.asynctasks_filetype = "ini"
	vim.g.asynctask_template = "~/.config/nvim/.task.ini"
	vim.g.asynctask_rootmarks = { ".git", "pyproject.toml" }
end
