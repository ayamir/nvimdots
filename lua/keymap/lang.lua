local bind = require("keymap.bind")
local map_cr = bind.map_cr
-- local map_cu = bind.map_cu
-- local map_cmd = bind.map_cmd
local map_callback = bind.map_callback

local safe_call_nabla = function()
	local nabla_ok, _ = pcall(vim.cmd, [[:lua require('nabla').popup({ border = 'rounded' })]])
	if not nabla_ok then
		vim.error("Put cursor inside latex expression")
	end
end

local latex_auto_end = function()
	vim.cmd("stopinsert")

	-- Get the current line and cursor position
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()

	-- Find the start and end of the \begin{...} tag
	local s, e = line:find("\\begin{%a+}")
	if s == nil or e == nil then
		return
	end

	-- Extract the environment name
	local env = line:sub(s + 7, e - 1)

	-- Insert \end{...} after the current line
	vim.api.nvim_buf_set_lines(0, row, row, false, { "" })
	vim.api.nvim_buf_set_lines(0, row + 1, row + 1, false, { "\\end{" .. env .. "}" })

	-- Move the cursor back to its original position
	vim.api.nvim_win_set_cursor(0, { row + 1, col })

	-- Schedule the re-entry to insert mode and feeding the tab key
	vim.schedule(function()
		vim.cmd("startinsert")
		vim.cmd("call feedkeys('\t')")
	end)
end

local plug_map = {
	-- Plugin MarkdownPreview
	["n|<F12>"] = map_cr("MarkdownPreviewToggle"):with_noremap():with_silent():with_desc("tool: Preview markdown"),
	["n|<leader>0"] = map_callback(safe_call_nabla):with_noremap():with_silent():with_desc("tool: Preview nabla"),

	-- Auto create endwise for latex file
	["i|]]"] = map_callback(latex_auto_end):with_noremap():with_silent():with_desc("tool: Auto create end for latex"),
}

bind.nvim_load_mapping(plug_map)
