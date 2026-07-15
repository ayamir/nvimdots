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
	-- on a single binary. `dlv` is resolved lazily on the spawn path only: a remote
	-- `attach` connects to an already-running `dlv dap` and needs no local binary,
	-- so the adapter must be registered even when `dlv` is absent (the availability
	-- check at the end of this file surfaces that case without unregistering).

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
				-- nvim-dap asserts tonumber(adapter.port) before its socket connect, so
				-- a non-numeric port could never reach the connect as-is; this coercion
				-- is about accepting a string user `config.port` and supplying delve's
				-- default 38697 when the value is absent or non-numeric (instead of
				-- tripping that assert with a less actionable message).
				port = tonumber(config.port) or 38697,
			})
		else
			-- Resolve lazily so a dlv installed after config load (a finished Mason
			-- install, say) is picked up without reconfiguring.
			local command = require("modules.utils.tools").find_executable("dlv")
			if not command then
				error("delve (dlv) not found on $PATH; install delve via Mason or your package manager", 0)
			end
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

	-- Availability check LAST, after the adapter and configurations are registered:
	-- erroring here lets the shared resolver surface `delve` in the aggregated
	-- missing-tool warning (or fall back to a Mason install), while remote attach —
	-- which needs no local dlv — keeps working with what was registered above.
	if not require("modules.utils.tools").find_executable("dlv") then
		error(
			"delve (dlv) not found on $PATH; local `dlv dap` launch is unavailable until installed"
				.. " (remote attach still works)",
			0
		)
	end
end
