return function()
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

	-- Start LSPs
	pcall(function()
		local matching_configs = nvim_lsp.util.get_config_by_ft(vim.bo.filetype)
		for _, config in ipairs(matching_configs) do
			config.launch()
		end
	end)
end
