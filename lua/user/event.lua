local definitions = {
	-- Example
	bufs = {
		{ "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
		{ "FileType", "markdown,tex,bib", "set wrap" },
	},
}

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		client.server_capabilities.semanticTokensProvider = nil
	end,
})

return definitions
