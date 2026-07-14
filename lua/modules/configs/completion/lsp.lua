return function()
	require("completion.neoconf").setup()
	-- All servers — including ones without a Mason package (dartls, say) — are
	-- resolved discovery-first from the single `lsp_deps` list inside
	-- mason-lspconfig.setup: a server whose manual spec names its binary is
	-- probed on $PATH and configured when present, so no per-server
	-- `vim.fn.executable(...)` special case is needed here.
	require("completion.mason-lspconfig").setup()

	pcall(require, "user.configs.lsp")

	-- Start LSPs
	pcall(vim.cmd.LspStart)
end
