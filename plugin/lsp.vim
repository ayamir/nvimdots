lua << EOF
local nvim_lsp = require('lspconfig')

nvim_lsp.pyright.setup{}
nvim_lsp.rust_analyzer.setup{}
nvim_lsp.tsserver.setup{}
nvim_lsp.gopls.setup{}
nvim_lsp.clangd.setup{}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		'documentation',
		'detail',
		'additionalTextEdits',
		}
	}

local servers = { "pyright", "rust_analyzer", "tsserver", "gopls", "clangd" }
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup {
		capabilities = capabilities,
		on_attach = function()
		require"lsp_signature".on_attach({
		bind = true,
		use_lspsaga = false,
		floating_window = true,
		fix_pos = true,
		hint_enable = true,
		hi_parameter = "Search",
		handler_opts = {
			"double"
			}
		})
end
}
end

EOF
