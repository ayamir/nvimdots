return function()
	vim.g.rustaceanvim = {
		-- DAP configuration
		dap = {
			adapter = {
				type = "executable",
				command = "lldb-vscode",
				name = "rt_lldb",
			},
		},
	}
end
