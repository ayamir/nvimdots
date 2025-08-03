return function()
	local nvim_lsp = require("lspconfig")
	require("completion.neoconf").setup()
	require("completion.mason").setup()
	require("completion.mason-lspconfig").setup()

	local opts = {
		capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
	}
	-- Configure LSPs that are not supported by `mason.nvim` but are available in `nvim-lspconfig` here.
	-- Call |vim.lsp.config()| FOLLOWED BY |vim.lsp.enable()| to ensure the server starts automatically.
	if vim.fn.executable("dart") == 1 then
		local ok, _opts = pcall(require, "user.configs.lsp-servers.dartls")
		if not ok then
			_opts = require("completion.servers.dartls")
		end
		local final_opts = vim.tbl_deep_extend("keep", _opts, opts)
		vim.lsp.config("dartls", final_opts)
		vim.lsp.enable("dartls")
	end

	pcall(require, "user.configs.lsp")
end
