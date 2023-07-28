local M = {}

local did_load_debug_mappings = false

local function remove_lsp_keymap(mode, map)
	for buf in pairs(_G._buf_with_lsp) do
		vim.api.nvim_buf_del_keymap(buf, mode, map)
	end
end
local function restore_lsp_keymap(mode, map, rhs, options)
	for buf in pairs(_G._buf_with_lsp) do
		vim.api.nvim_buf_set_keymap(buf, mode, map, rhs, options)
	end
end

function M.load_extras()
	if not did_load_debug_mappings then
		remove_lsp_keymap("n", "K")
		vim.api.nvim_del_keymap("v", "K")
		vim.api.nvim_set_keymap("n", "K", "<Cmd>lua require('dapui').eval()<CR>", {
			desc = "debug: Evaluate expression under cursor",
			expr = false,
			noremap = true,
			nowait = true,
			silent = true,
		})
		vim.api.nvim_set_keymap("v", "K", "<Cmd>lua require('dapui').eval()<CR>", {
			desc = "debug: Evaluate expression under cursor",
			expr = false,
			noremap = true,
			nowait = true,
			silent = true,
		})
		did_load_debug_mappings = true
	end
end

function M.restore()
	if did_load_debug_mappings then
		vim.api.nvim_del_keymap("n", "K")
		vim.api.nvim_del_keymap("v", "K")
		restore_lsp_keymap("n", "K", ":Lspsaga hover_doc<CR>", {
			desc = "lsp: Show doc",
			expr = false,
			noremap = true,
			nowait = false,
			silent = true,
		})
		vim.api.nvim_set_keymap("v", "K", ":m '<-2<CR>gv=gv", {
			expr = false,
			noremap = false,
			nowait = false,
			silent = false,
		})
		did_load_debug_mappings = false
	end
end

return M
