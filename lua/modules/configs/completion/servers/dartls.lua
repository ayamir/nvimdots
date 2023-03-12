-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/dartls.lua
return {
	cmd = { "dart", "language-server", "--protocol=lsp" },
	filetypes = { "dart" },
	init_options = {
		closingLabels = true,
		flutterOutline = true,
		onlyAnalyzeProjectsWithOpenFiles = true,
		outline = true,
		suggestFromUnimportedLibraries = true,
	},
}
