-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/gopls.lua
return {
	flags = { debounce_text_changes = 500 },
	cmd = { "gopls", "-remote=auto" },
	settings = {
		gopls = {
			usePlaceholders = true,
			analyses = {
				nilness = true,
				shadow = true,
				unusedparams = true,
				unusewrites = true,
			},
		},
	},
}
