return function()
	local dap = require("dap")
	local dap_utils = require("modules.configs.tool.dap.utils")

	local codelldb = vim.fn.exepath("codelldb")
	local path_to_program = dap_utils.path_to_program()

	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			-- CHANGE THIS to your path!
			command = codelldb,
			args = { "--port", "${port}" },
			-- On windows you may have to uncomment this:
			-- detached = false,
		},
	}

	dap.configurations.cpp = {
		{
			name = "Launch file",
			type = "codelldb",
			request = "launch",
			program = path_to_program,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
		},
	}
	dap.configurations.c = dap.configurations.cpp
	dap.configurations.rust = dap.configurations.cpp
end
