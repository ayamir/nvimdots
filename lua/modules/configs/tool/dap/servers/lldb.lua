return function(config)
	local dap = require("dap")
	local dap_utils = require("modules.configs.tool.dap.utils")

	-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-lldb-vscode
	local lldb_abspath = vim.fn.exepath("lldb-vscode")
	local path_to_program = dap_utils.path_to_program()
	local get_env = dap_utils.get_env()
	local input_args = dap_utils.input_args()

	dap.adapters.lldb = {
		type = "executable",
		command = lldb_abspath,
		name = "lldb",
	}
	dap.configurations.cpp = {
		{
			name = "Launch",
			type = "lldb",
			request = "launch",
			program = path_to_program,
			cwd = "${workspaceFolder}",
			env = get_env,
			args = input_args,
			stopOnEntry = false,
			-- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
			--
			--    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
			--
			-- Otherwise you might get the following error:
			--
			--    Error on launch: Failed to attach to the target process
			--
			-- But you should be aware of the implications:
			-- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
			runInTerminal = false,
		},
	}

	dap.configurations.c = dap.configurations.cpp
	dap.configurations.rust = dap.configurations.cpp
end
