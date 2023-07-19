-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/lua_ls.lua
return {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
				disable = { "different-requires" },
			},
			hint = {
				enable = true,
				setType = true,
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					[vim.fn.stdpath("data") .. "/site/lazy/neodev.nvim/types"] = true,
					["${3rd}/luv/library"] = true,
				},
				maxPreload = 100000,
				preloadFileSize = 10000,
				checkThirdParty = false,
			},
			format = { enable = false },
			telemetry = { enable = false },
			completion = { callSnippet = "Replace" },
			-- Do not override treesitter lua highlighting with lua_ls's highlighting
			semantic = { enable = false },
		},
	},
}
