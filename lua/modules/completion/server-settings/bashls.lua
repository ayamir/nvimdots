-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/bashls.lua
return {
	cmd = { "bash-language-server", "start" },
	filetypes = { "bash", "sh" },
}
