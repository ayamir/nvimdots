-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#python
-- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
return function()
	local dap = require("dap")
	local is_windows = require("core.global").is_windows
	local data_dir = require("core.global").data_dir
	local python = is_windows and data_dir .. "../mason/packages/debugpy/venv/Scripts/pythonw.exe"
		or data_dir .. "../mason/packages/debugpy/venv/bin/python"
	local utils = require("modules.utils.dap")

	local function is_empty(s)
		return s == nil or s == ""
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
			callback({
				type = "executable",
				command = python,
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
				if not is_empty(vim.env.CONDA_PREFIX) then
					return is_windows and vim.env.CONDA_PREFIX .. "/Scripts/pythonw.exe"
						or vim.env.CONDA_PREFIX .. "/bin/python"
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
				local cwd, venv = vim.fn.getcwd(), os.getenv("VIRTUAL_ENV")
				if
					venv
					and (
						vim.fn.executable(venv .. "/bin/python") == 1
						or vim.fn.executable(venv .. "/Scripts/pythonw.exe") == 1
					)
				then
					return is_windows and venv .. "/Scripts/pythonw.exe" or venv .. "/bin/python"
				elseif
					(vim.fn.executable(cwd .. "/venv/bin/python") == 1)
					or (vim.fn.executable(cwd .. "/venv/Scripts/pythonw.exe") == 1)
				then
					return is_windows and cwd .. "/venv/Scripts/pythonw.exe" or cwd .. "/venv/bin/python"
				elseif
					(vim.fn.executable(cwd .. "/.venv/bin/python") == 1)
					or (vim.fn.executable(cwd .. "/.venv/Scripts/pythonw.exe") == 1)
				then
					return is_windows and cwd .. "/.venv/Scripts/pythonw.exe" or cwd .. "/.venv/bin/python"
				else
					return is_windows and "pythonw.exe" or "python3"
				end
			end,
		},
	}
end
