-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#python
-- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
return function()
	local dap = require("dap")
	local utils = require("modules.utils.dap")
	local is_windows = require("core.global").is_windows
	local debugpy_root = require("mason-registry").get_package("debugpy"):get_install_path()

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
			callback({
				type = "executable",
				command = is_windows and debugpy_root .. "/venv/Scripts/pythonw.exe"
					or debugpy_root .. "/venv/bin/python",
				args = { "-m", "debugpy.adapter" },
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
				local cwd, venv = vim.fn.getcwd(), os.getenv("VIRTUAL_ENV")
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
