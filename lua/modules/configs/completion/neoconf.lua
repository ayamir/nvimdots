local M = {}

M.setup = function()
	require("modules.utils").load_plugin("neoconf", {
		-- send new configuration to lsp clients when changing json settings
		live_reload = true,
		-- name of the local settings files
		local_settings = ".neoconf.json",
		-- name of the global settings file in your Neovim config directory
		global_settings = "neoconf.json",
		-- import existing settings from other plugins
		import = {
			vscode = true, -- local .vscode/settings.json
			coc = true, -- global/local coc-settings.json
			nlsp = true, -- global/local nlsp-settings.nvim json settings
		},
	})
end

return M
