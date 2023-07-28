local M = {}

local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cmd = bind.map_cmd

local did_load_debug_mappings = false
local keymap_info_debug = {
	n = { K = false },
	v = { K = false },
}
local keymap_info_original = {
	n = { K = true },
	v = { K = false },
}
local debug_keymap = {
	["nv|K"] = map_cmd("<Cmd>lua require('dapui').eval()<CR>")
		:with_noremap()
		:with_nowait()
		:with_desc("debug: Evaluate expression under cursor"),
}
local original_keymap = {
	["n|K"] = map_cr("Lspsaga hover_doc"):with_noremap():with_silent():with_desc("lsp: Show doc"),
	["v|K"] = map_cmd(":m '<-2<CR>gv=gv"),
}

local function del_keymap(mappings, keymap_info)
	for key in pairs(mappings) do
		local modes, keymap = key:match("([^|]*)|?(.*)")
		for _, mode in ipairs(vim.split(modes, "")) do
			if vim.fn.maparg(keymap, mode, false) ~= "" then
				if keymap_info[mode][keymap] == true then
					vim.api.nvim_buf_del_keymap(0, mode, keymap)
				else
					vim.api.nvim_del_keymap(mode, keymap)
				end
			end
		end
	end
end

local function load_keymap(mappings, keymap_info)
	for key, value in pairs(mappings) do
		local modes, keymap = key:match("([^|]*)|?(.*)")
		if type(value) == "table" then
			for _, mode in ipairs(vim.split(modes, "")) do
				local rhs = value.cmd
				local options = value.options
				if keymap_info[mode][keymap] == true then
					for buf in pairs(_G._lspkeymap_loaded_bufnr) do
						-- Restore lsp keymaps
						vim.api.nvim_buf_set_keymap(buf, mode, keymap, rhs, options)
					end
				else
					vim.api.nvim_set_keymap(mode, keymap, rhs, options)
				end
			end
		end
	end
end

function M.load()
	if not did_load_debug_mappings then
		del_keymap(original_keymap, keymap_info_original)
		load_keymap(debug_keymap, keymap_info_debug)
		did_load_debug_mappings = true
	end
end

function M.restore()
	if did_load_debug_mappings then
		del_keymap(debug_keymap, keymap_info_debug)
		load_keymap(original_keymap, keymap_info_original)
		did_load_debug_mappings = false
	end
end

return M
