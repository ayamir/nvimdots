-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/lua_ls.lua
return {
	cmd = { "lua-language-server" },
	settings = {
		Lua = {
			format = { enable = false },
			telemetry = { enable = false },
			-- Do not override treesitter lua highlighting with lua_ls' highlighting
			semantic = { enable = false },
		},
	},
}
