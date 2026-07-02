-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#python
-- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
return function()
	local dap = require("dap")
	local utils = require("modules.utils.dap")
	local is_windows = require("core.global").is_windows
	-- Resolve Mason's install root via the settings API (nil when Mason isn't
	-- available), not the $MASON env var alone — it's only set as a side effect of
	-- mason.setup() and may not be exported.
	local mason_root = require("modules.utils.tools").mason_root()
	local debugpy_root = mason_root and (mason_root .. "/packages/debugpy") or nil

	-- Resolve the debugpy adapter command discovery-first: prefer Mason's managed
	-- venv, then a `debugpy-adapter` on $PATH, then a system python running the
	-- debugpy module. This keeps python debugging working without Mason (BSD/NixOS),
	-- where the hard-coded Mason path would otherwise point at a missing directory.
	local function debugpy_command()
		if debugpy_root then
			local mason_python = is_windows and debugpy_root .. "/venv/Scripts/pythonw.exe"
				or debugpy_root .. "/venv/bin/python"
			if vim.fn.executable(mason_python) == 1 then
				return mason_python, { "-m", "debugpy.adapter" }
			end
		end
		if vim.fn.executable("debugpy-adapter") == 1 then
			return "debugpy-adapter", {}
		end
		-- Last resort: a python interpreter on $PATH that can run debugpy. Probe
		-- candidates rather than hard-coding one, so we don't hand nvim-dap a
		-- command that isn't installed (e.g. pythonw.exe is often absent on a
		-- Windows box that only has python.exe / python).
		local candidates = is_windows and { "pythonw.exe", "python.exe", "python" } or { "python3", "python" }
		for _, py in ipairs(candidates) do
			if vim.fn.executable(py) == 1 then
				return py, { "-m", "debugpy.adapter" }
			end
		end
		-- None resolved; return the conventional interpreter name so a failure at
		-- least names a real command rather than a windowless-only pythonw.exe.
		return candidates[#candidates], { "-m", "debugpy.adapter" }
	end

	dap.adapters.python = function(callback, config)
		if config.request == "attach" then
			local port = (config.connect or config).port
			local host = (config.connect or config).host or "127.0.0.1"
			callback({
				type = "server",
				port = assert(port, "`connect.port` is required for a python `attach` configuration"),
				host = host,
				options = { source_filetype = "python" },
			})
		else
			local command, args = debugpy_command()
			callback({
				type = "executable",
				command = command,
				args = args,
				options = { source_filetype = "python" },
			})
		end
	end
	dap.configurations.python = {
		{
			-- The first three options are required by nvim-dap
			type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
			request = "launch",
			name = "Debug",
			-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
			console = "integratedTerminal",
			program = utils.input_file_path(),
			pythonPath = function()
				local venv = vim.env.CONDA_PREFIX
				if venv then
					return is_windows and venv .. "/Scripts/pythonw.exe" or venv .. "/bin/python"
				else
					return is_windows and "pythonw.exe" or "python3"
				end
			end,
		},
		{
			-- NOTE: This setting is for people using venv
			type = "python",
			request = "launch",
			name = "Debug (using venv)",
			-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
			console = "integratedTerminal",
			program = utils.input_file_path(),
			pythonPath = function()
				-- Prefer the venv that is defined by the designated environment variable.
				local cwd, venv = vim.uv.cwd(), vim.env.VIRTUAL_ENV
				local python = venv and (is_windows and venv .. "/Scripts/pythonw.exe" or venv .. "/bin/python") or ""
				if vim.fn.executable(python) == 1 then
					return python
				end

				-- Otherwise, fall back to check if there are any local venvs available.
				venv = vim.fn.isdirectory(cwd .. "/venv") == 1 and cwd .. "/venv" or cwd .. "/.venv"
				python = is_windows and venv .. "/Scripts/pythonw.exe" or venv .. "/bin/python"
				if vim.fn.executable(python) == 1 then
					return python
				else
					return is_windows and "pythonw.exe" or "python3"
				end
			end,
		},
	}
end
