-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-lldb-vscode
return function()
	local dap = require("dap")
	local utils = require("modules.utils.dap")

	-- Self-validate the binary so the shared resolver (which pcalls this config)
	-- surfaces `lldb` in the aggregated missing-tool warning instead of registering
	-- an adapter with an empty command that only fails at debug time.
	local command = vim.fn.exepath("lldb-vscode")
	if command == "" then
		error("lldb-vscode not found on $PATH; install it via your package manager (ships with LLVM/lldb)")
	end

	dap.adapters.lldb = {
		type = "executable",
		command = command,
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
