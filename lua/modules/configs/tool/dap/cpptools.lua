local dap = require("dap")
local dap_utils = require("modules.configs.tool.dap.utils")

-- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
local gdb_abspath = vim.fn.exepath("gdb")
local cpptools_abspath = vim.fn.stdpath("data") .. "/dap/cpptools/extension/debugAdapters/bin/OpenDebugAD7"
local path_to_program = dap_utils.path_to_program()
local get_env = dap_utils.get_env()
local setupCommands = {
	text = "-enable-pretty-printing",
	description = "enable pretty printing",
	ignoreFailures = false,
}

dap.adapters.cppdbg = {
	id = "cppdbg",
	type = "executable",
	command = cpptools_abspath,
}
dap.configurations.cpp = {
	{
		name = "Launch file",
		type = "cppdbg",
		request = "launch",
		program = path_to_program,
		cwd = "${workspaceFolder}",
		env = get_env,
		setupCommands = setupCommands,
		stopAtEntry = false,
	},
	{
		name = "Attach to gdbserver :1234",
		type = "cppdbg",
		request = "launch",
		MIMode = "gdb",
		miDebuggerServerAddress = "localhost:1234",
		miDebuggerPath = gdb_abspath,
		program = path_to_program,
		cwd = "${workspaceFolder}",
		env = get_env,
		setupCommands = setupCommands,
	},
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
