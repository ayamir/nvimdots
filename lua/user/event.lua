local definitions = {
	-- Example
	bufs = {
		{ "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
		-- { "BufEnter", "*",

		-- auto change directory
		-- { "BufEnter", "*", "silent! lcd %:p:h" },
	},
}

-- local function set_buffer_root()
-- 	local current_file = vim.fn.expand("%:p:h")
-- 	local current_cwd = vim.fn.expand("%:p")
-- 	if current_file ~= "" and current_file ~= "NvimTree_" then
-- 		-- print(current_cwd)
-- 		print(current_file)
-- 	end
-- end

-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	pattern = "*",
-- 	callback = set_buffer_root(),
-- })

-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	pattern = "*",
-- 	callback = function()
-- 		local current_file_dir = vim.fn.expand("%:p:h")
-- 		vim.api.nvim_set_current_dir(current_file_dir)
-- 		print(current_file_dir)
-- 	end,
-- })

return definitions
