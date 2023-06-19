-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-lldb-vscode
return function()
	local dap = require("dap")
	local utils = require("modules.utils.dap")

	dap.adapters.lldb = {
		type = "executable",
		command = "lldb-vscode",
		name = "lldb",
	}
	dap.configurations.c = {
		{
			name = "Launch",
			type = "lldb",
			request = "launch",
			program = utils.input_exec_path(),
			cwd = "${workspaceFolder}",
			args = utils.input_args(),
			env = utils.get_env(),

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

	dap.configurations.cpp = dap.configurations.c
	dap.configurations.rust = dap.configurations.c
end
