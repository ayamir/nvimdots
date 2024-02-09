return function()
	vim.g.rustaceanvim = {
		-- Disable automatic DAP configuration to avoid conflicts with previous user configs
		dap = {
			adapter = false,
			configuration = false,
			autoload_configurations = false,
		},
	}

	require("modules.utils").load_plugin("rustaceanvim", nil, true)
end
