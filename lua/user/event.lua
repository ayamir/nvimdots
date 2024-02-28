local definitions = {
	-- Example
	bufs = {
		{ "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
		-- { "BufEnter", "*",

		-- auto change directory
		{ "BufFilePre", "*", "silent! cd %:p:h" },
		-- { "bufnr, bufwinid, bufwin", "*", "echo %:p:h " },

		-- auto place to last edit
		-- {
		-- 	"BufReadPost",
		-- 	"*",
		-- 	[[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif]],
		-- },
	},

	-- vim.api.nvim_create_autocmd("LspAttach", {
	-- 	group = vim.api.nvim_create_augroup("LspKeymapLoader", { clear = true }),
	-- 	callback = function(event)
	-- 		if not _G._debugging then
	-- 			mapping.lsp(event.buf)
	-- 		end
	-- 	end,
	-- }),

	-- vim.api.nvim_create_autocmd("LspAttach", {
	-- 	group = vim.api.nvim_create_augroup("LspKeymapLoader", { clear = true }),
	-- 	callback = function(event)
	-- 		if not _G._debugging then
	-- 			mapping.lsp(event.buf)
	-- 		end
	-- 	end,
	-- }),
}

return definitions
