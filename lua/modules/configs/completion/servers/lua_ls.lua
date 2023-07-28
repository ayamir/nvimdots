-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/lua_ls.lua
return {
	cmd = { "lua-language-server" },
	settings = {
		Lua = {
			-- keep it commneted until 0.10 got released
			-- hint = { enable = true, setType = true },
			format = { enable = false },
			telemetry = { enable = false },
			-- Do not override treesitter lua highlighting with lua_ls' highlighting
			semantic = { enable = false },
		},
	},
}
