-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#python
return function()
	local dap = require("dap")
	local debugpy = vim.fn.exepath("debugpy-adapter")

	local function is_empty(s)
		return s == nil or s == ""
	end

	dap.adapters.python = function(callback, config)
		if config.request == "attach" then
			---@diagnostic disable-next-line: undefined-field
			local port = (config.connect or config).port
			---@diagnostic disable-next-line: undefined-field
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
				command = debugpy,
				options = { source_filetype = "python" },
			})
		end
	end
	dap.configurations.python = {
		{
			-- The first three options are required by nvim-dap
			type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
			request = "launch",
			name = "Launch file",
			-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
			program = "${file}", -- This configuration will launch the current file if used.
			pythonPath = function()
				if not is_empty(vim.env.CONDA_PREFIX) then
					return vim.env.CONDA_PREFIX .. "/bin/python"
				else
					return "python3"
				end
			end,
		},
	}

	-- NOTE: This setting is for people using venv
	-- pythonPath = function()
	-- 	-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
	-- 	-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
	-- 	-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
	-- 	local cwd, venv = vim.fn.getcwd(), os.getenv("VIRTUAL_ENV")
	-- 	if venv and vim.fn.executable(venv .. "/bin/python") == 1 then
	-- 		return venv .. "/bin/python"
	-- 	elseif vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
	-- 		return cwd .. "/venv/bin/python"
	-- 	elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
	-- 		return cwd .. "/.venv/bin/python"
	-- 	else
	-- 		return "python3"
	-- 	end
	-- end,
end
