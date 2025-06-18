return function()
	local nvim_lsp = require("lspconfig")
	require("completion.neoconf").setup()
	require("completion.mason").setup()
	require("completion.mason-lspconfig").setup()

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local opts = {
		capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false)),
	}
	-- Setup lsps that are not supported by `mason.nvim` but supported by `nvim-lspconfig` here.
	if vim.fn.executable("dart") == 1 then
		local ok, _opts = pcall(require, "user.configs.lsp-servers.dartls")
		if not ok then
			_opts = require("completion.servers.dartls")
		end
		local final_opts = vim.tbl_deep_extend("keep", _opts, opts)
		nvim_lsp.dartls.setup(final_opts)
	end

	pcall(require, "user.configs.lsp")
end
