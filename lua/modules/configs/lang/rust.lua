return function()
	vim.g.rustaceanvim = {
		-- Disable automatic DAP configuration to avoid conflicts with previous user configs
		dap = {
			adapter = false,
			configuration = false,
			autoload_configurations = false,
		},
		tools = {
			executor = require("rustaceanvim.executors").toggleterm,
			reload_workspace_from_cargo_toml = true,
		},
		server = { standalone = true },
	}

	require("modules.utils").load_plugin("rustaceanvim", nil, true)
end
