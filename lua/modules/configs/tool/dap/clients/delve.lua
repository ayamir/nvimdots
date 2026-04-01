-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#go
-- https://github.com/golang/vscode-go/blob/master/docs/debugging.md
return function()
	local dap = require("dap")
	local utils = require("modules.utils.dap")

	if not require("mason-registry").is_installed("go-debug-adapter") then
		vim.notify(
			"Automatically installing `go-debug-adapter` for go debugging",
			vim.log.levels.INFO,
			{ title = "nvim-dap" }
		)

		local go_dbg = require("mason-registry").get_package("go-debug-adapter")
		go_dbg:install():once(
			"closed",
			vim.schedule_wrap(function()
				if go_dbg:is_installed() then
					vim.notify("Successfully installed `go-debug-adapter`", vim.log.levels.INFO, { title = "nvim-dap" })
				end
			end)
		)
	end

	dap.adapters.go = {
		type = "executable",
		command = vim.fn.exepath("go-debug-adapter"), -- Find go-debug-adapter on $PATH
	}
	dap.configurations.go = {
		{
			type = "go",
			name = "Debug (file)",
			request = "launch",
			cwd = "${workspaceFolder}",
			program = utils.input_file_path(),
			console = "integratedTerminal",
			dlvToolPath = vim.fn.exepath("dlv"),
			showLog = true,
			showRegisters = true,
			stopOnEntry = false,
		},
		{
			type = "go",
			name = "Debug (file with args)",
			request = "launch",
			cwd = "${workspaceFolder}",
			program = utils.input_file_path(),
			args = utils.input_args(),
			console = "integratedTerminal",
			dlvToolPath = vim.fn.exepath("dlv"),
			showLog = true,
			showRegisters = true,
			stopOnEntry = false,
		},
		{
			type = "go",
			name = "Debug (executable)",
			request = "launch",
			cwd = "${workspaceFolder}",
			program = utils.input_exec_path(),
			args = utils.input_args(),
			console = "integratedTerminal",
			dlvToolPath = vim.fn.exepath("dlv"),
			mode = "exec",
			showLog = true,
			showRegisters = true,
			stopOnEntry = false,
		},
		{
			type = "go",
			name = "Debug (test file)",
			request = "launch",
			cwd = "${workspaceFolder}",
			program = utils.input_file_path(),
			console = "integratedTerminal",
			dlvToolPath = vim.fn.exepath("dlv"),
			mode = "test",
			showLog = true,
			showRegisters = true,
			stopOnEntry = false,
		},
		{
			type = "go",
			name = "Debug (using go.mod)",
			request = "launch",
			cwd = "${workspaceFolder}",
			program = "./${relativeFileDirname}",
			console = "integratedTerminal",
			dlvToolPath = vim.fn.exepath("dlv"),
			mode = "test",
			showLog = true,
			showRegisters = true,
			stopOnEntry = false,
		},
	}
end
