-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#go-using-delve-directly
-- https://github.com/golang/vscode-go/blob/master/docs/debugging.md
return function()
	local dap = require("dap")
	local utils = require("modules.utils.dap")
	local is_windows = require("core.global").is_windows

	-- Use delve's built-in DAP server (`dlv dap`) directly as the adapter — no
	-- separate go-debug-adapter. This keeps Go debugging working wherever `dlv` is
	-- available (system or Mason) and matches how `tool/dap/init.lua` resolves the
	-- `delve` Mason package (bin `dlv`), so discovery/install and configuration agree
	-- on a single binary. The resolver runs this under pcall, so erroring when `dlv`
	-- is absent lets it mark `delve` as missing (with this message) instead of
	-- configuring an adapter that can't launch.
	local command = vim.fn.exepath("dlv")
	if command == "" then
		error("delve (dlv) not found on $PATH; install delve via Mason or your package manager")
	end

	---Spawn `dlv dap` as a server adapter, binding to the port nvim-dap allocates.
	---A function adapter (over a static table) so a remote `attach` config can
	---connect to an already-running `dlv dap` instead of spawning a local one.
	---@param callback fun(adapter: table)
	---@param config table
	local function delve_adapter(callback, config)
		if config.request == "attach" and config.mode == "remote" then
			callback({
				type = "server",
				host = config.host or "127.0.0.1",
				-- Coerce to a number (and default to an integer): nvim-dap tonumber()s the
				-- port itself, but a non-numeric user `config.port` would otherwise reach
				-- the socket connect as-is; this guarantees an integer or the default.
				port = tonumber(config.port) or 38697,
			})
		else
			callback({
				type = "server",
				port = "${port}",
				executable = {
					command = command,
					args = { "dap", "-l", "127.0.0.1:${port}" },
					detached = not is_windows,
				},
			})
		end
	end

	-- Register under both names: the configurations below use `type = "go"`, while
	-- mason-nvim-dap / other integrations reference the adapter as `delve`.
	dap.adapters.go = delve_adapter
	dap.adapters.delve = delve_adapter

	dap.configurations.go = {
		{
			type = "go",
			name = "Debug (file)",
			request = "launch",
			cwd = "${workspaceFolder}",
			program = utils.input_file_path(),
			console = "integratedTerminal",
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
			mode = "test",
			showLog = true,
			showRegisters = true,
			stopOnEntry = false,
		},
	}
end
