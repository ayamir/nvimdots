-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#go
-- https://github.com/golang/vscode-go/blob/master/docs/debugging.md
return function()
	local dap = require("dap")
	local utils = require("modules.utils.dap")

	-- Mason is optional here: guard the registry require so a Mason-less setup
	-- degrades gracefully (no auto-install) instead of hard-erroring, mirroring the
	-- discovery-first guarding in `python.lua`. Only auto-install when the binary is
	-- neither Mason-installed nor already on $PATH, so a system-provided
	-- go-debug-adapter is used as-is (and configured this session) instead of
	-- triggering a redundant Mason install and deferring to the next launch.
	local has_registry, registry = pcall(require, "mason-registry")
	if has_registry and not registry.is_installed("go-debug-adapter") and vim.fn.exepath("go-debug-adapter") == "" then
		-- get_package throws when the name isn't in the registry (registry skew).
		-- Guard it so that turns into a clear, actionable error the resolver's pcall
		-- can surface, rather than a generic "missing" with the install path skipped.
		local ok, go_dbg = pcall(registry.get_package, "go-debug-adapter")
		if not ok then
			error("go-debug-adapter is not in the Mason registry (registry outdated?); run :MasonUpdate")
		end

		vim.notify(
			"Automatically installing `go-debug-adapter` for go debugging",
			vim.log.levels.INFO,
			{ title = "nvim-dap" }
		)

		go_dbg:install():once(
			"closed",
			vim.schedule_wrap(function()
				if go_dbg:is_installed() then
					vim.notify("Successfully installed `go-debug-adapter`", vim.log.levels.INFO, { title = "nvim-dap" })
				end
			end)
		)
		-- The install was just kicked off (user informed via the INFO notification
		-- above); its binary won't be on $PATH until it finishes. Configure on the
		-- next launch rather than erroring below and being flagged "missing" while
		-- it's already installing.
		return
	end

	-- Reached only when Mason is absent or go-debug-adapter is already installed.
	-- Resolve it on $PATH; if it isn't there, error out instead of configuring an
	-- empty command. The resolver in `tool/dap/init.lua` runs this under pcall, so
	-- throwing lets it mark `delve` as missing rather than silently leaving Go
	-- debugging broken.
	local command = vim.fn.exepath("go-debug-adapter")
	if command == "" then
		error("go-debug-adapter not found on $PATH; install it via Mason or your package manager")
	end
	dap.adapters.go = {
		type = "executable",
		command = command,
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
