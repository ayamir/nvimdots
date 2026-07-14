-- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)
return function()
	local dap = require("dap")
	local utils = require("modules.utils.dap")
	local is_windows = require("core.global").is_windows

	-- Config-time self-validation: error out when codelldb isn't on $PATH so the
	-- resolver in `tool/dap/init.lua` (which pcalls this config) surfaces `codelldb`
	-- in the aggregated missing-tool warning — instead of registering an adapter
	-- with an empty command that only fails once a debug session starts. Every
	-- codelldb branch (launch and attach) spawns the local binary, so unlike
	-- delve/python there is no adapter worth registering without it.
	local command =
		require("modules.utils.tools").exepath_or_error("codelldb", "install it via Mason or your package manager")
	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = command,
			args = { "--port", "${port}" },
			detached = not is_windows,
		},
	}
	dap.configurations.c = {
		{
			name = "Debug",
			type = "codelldb",
			request = "launch",
			program = utils.input_exec_path(),
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			terminal = "integrated",
		},
		{
			name = "Debug (with args)",
			type = "codelldb",
			request = "launch",
			program = utils.input_exec_path(),
			args = utils.input_args(),
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			terminal = "integrated",
		},
		{
			name = "Attach to a running process",
			type = "codelldb",
			request = "attach",
			program = utils.input_exec_path(),
			stopOnEntry = false,
			waitFor = true,
		},
	}
	dap.configurations.cpp = dap.configurations.c
	dap.configurations.rust = dap.configurations.c
end
