-- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)
return function()
	local dap = require("dap")
	local utils = require("modules.utils.dap")

	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = vim.fn.exepath("codelldb"), -- Find codelldb on $PATH
			args = { "--port", "${port}" },
			-- On windows you may have to uncomment this:
			-- detached = false,
		},
	}
	dap.configurations.c = {
		{
			name = "Launch the debugger",
			type = "codelldb",
			request = "launch",
			program = utils.input_exec_path(),
			args = utils.input_args(),
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
		},
	}
	dap.configurations.cpp = dap.configurations.c
	dap.configurations.rust = dap.configurations.c
end
