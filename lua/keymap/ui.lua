local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback

local mappings = {
	builtins = {
		-- Builtins: Buffer
		["n|<leader>bn"] = map_cu("enew"):with_noremap():with_silent():with_desc("buffer: New"),

		-- Builtins: Terminal
		["t|<C-w>h"] = map_cmd("<Cmd>wincmd h<CR>"):with_silent():with_noremap():with_desc("window: Focus left"),
		["t|<C-w>l"] = map_cmd("<Cmd>wincmd l<CR>"):with_silent():with_noremap():with_desc("window: Focus right"),
		["t|<C-w>j"] = map_cmd("<Cmd>wincmd j<CR>"):with_silent():with_noremap():with_desc("window: Focus down"),
		["t|<C-w>k"] = map_cmd("<Cmd>wincmd k<CR>"):with_silent():with_noremap():with_desc("window: Focus up"),

		-- Builtins: Tabpage
		["n|tn"] = map_cr("tabnew"):with_noremap():with_silent():with_desc("tab: Create a new tab"),
		["n|tk"] = map_cr("tabnext"):with_noremap():with_silent():with_desc("tab: Move to next tab"),
		["n|tj"] = map_cr("tabprevious"):with_noremap():with_silent():with_desc("tab: Move to previous tab"),
		["n|to"] = map_cr("tabonly"):with_noremap():with_silent():with_desc("tab: Only keep current tab"),
	},
	plugins = {
		-- Plugin: nvim-bufdel
		["n|<A-q>"] = map_cr("BufDel"):with_noremap():with_silent():with_desc("buffer: Close current"),
		["n|<A-S-q>"] = map_callback(function()
				require("nvchad.tabufline").closeAllBufs(false)
			end)
			:with_noremap()
			:with_silent()
			:with_desc("buffer: Close others"),

		-- Plugin: bufferline.nvim
		["n|<A-i>"] = map_callback(function()
				require("nvchad.tabufline").next()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("buffer: Switch to next"),
		["n|<A-o>"] = map_callback(function()
				require("nvchad.tabufline").prev()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("buffer: Switch to prev"),
		["n|<A-S-i>"] = map_callback(function()
				require("nvchad.tabufline").move_buf(1)
			end)
			:with_noremap()
			:with_silent()
			:with_desc("buffer: Move current to next"),
		["n|<A-S-o>"] = map_callback(function()
				require("nvchad.tabufline").move_buf(-1)
			end)
			:with_noremap()
			:with_silent()
			:with_desc("buffer: Move current to prev"),

		-- Plugin: smart-splits.nvim
		["n|<A-h>"] = map_cu("SmartResizeLeft")
			:with_silent()
			:with_noremap()
			:with_desc("window: Resize -3 horizontally"),
		["n|<A-j>"] = map_cu("SmartResizeDown"):with_silent():with_noremap():with_desc("window: Resize -3 vertically"),
		["n|<A-k>"] = map_cu("SmartResizeUp"):with_silent():with_noremap():with_desc("window: Resize +3 vertically"),
		["n|<A-l>"] = map_cu("SmartResizeRight")
			:with_silent()
			:with_noremap()
			:with_desc("window: Resize +3 horizontally"),
		["n|<C-h>"] = map_cu("SmartCursorMoveLeft"):with_silent():with_noremap():with_desc("window: Focus left"),
		["n|<C-j>"] = map_cu("SmartCursorMoveDown"):with_silent():with_noremap():with_desc("window: Focus down"),
		["n|<C-k>"] = map_cu("SmartCursorMoveUp"):with_silent():with_noremap():with_desc("window: Focus up"),
		["n|<C-l>"] = map_cu("SmartCursorMoveRight"):with_silent():with_noremap():with_desc("window: Focus right"),
		["n|<leader>Wh"] = map_cu("SmartSwapLeft")
			:with_silent()
			:with_noremap()
			:with_desc("window: Move window leftward"),
		["n|<leader>Wj"] = map_cu("SmartSwapDown")
			:with_silent()
			:with_noremap()
			:with_desc("window: Move window downward"),
		["n|<leader>Wk"] = map_cu("SmartSwapUp"):with_silent():with_noremap():with_desc("window: Move window upward"),
		["n|<leader>Wl"] = map_cu("SmartSwapRight")
			:with_silent()
			:with_noremap()
			:with_desc("window: Move window rightward"),
	},
}

-- Goto buffer with <A-number>
for i = 1, 9, 1 do
	mappings.plugins[string.format("n|<A-%s>", i)] = map_callback(function()
			vim.api.nvim_set_current_buf(vim.t.bufs[i])
		end)
		:with_noremap()
		:with_silent()
		:with_desc("buffer: Goto buffer " .. tostring(i))
end

bind.nvim_load_mapping(mappings.builtins)
bind.nvim_load_mapping(mappings.plugins)

--- The following code enables this file to be exported ---
---  for use with gitsigns lazy-loaded keymap bindings  ---

local M = {}

function M.gitsigns(bufnr)
	local gitsigns = require("gitsigns")
	local map = {
		["n|]g"] = map_callback(function()
				if vim.wo.diff then
					return "]g"
				end
				vim.schedule(function()
					gitsigns.nav_hunk("next")
				end)
				return "<Ignore>"
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_expr()
			:with_desc("git: Goto next hunk"),
		["n|[g"] = map_callback(function()
				if vim.wo.diff then
					return "[g"
				end
				vim.schedule(function()
					gitsigns.nav_hunk("prev")
				end)
				return "<Ignore>"
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_expr()
			:with_desc("git: Goto prev hunk"),
		["n|<leader>gs"] = map_callback(function()
				gitsigns.stage_hunk()
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("git: Toggle staging/unstaging of hunk"),
		["v|<leader>gs"] = map_callback(function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("git: Toggle staging/unstaging of selected hunk"),
		["n|<leader>gr"] = map_callback(function()
				gitsigns.reset_hunk()
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("git: Reset hunk"),
		["v|<leader>gr"] = map_callback(function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("git: Reset hunk"),
		["n|<leader>gR"] = map_callback(function()
				gitsigns.reset_buffer()
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("git: Reset buffer"),
		["n|<leader>gp"] = map_callback(function()
				gitsigns.preview_hunk()
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("git: Preview hunk"),
		["n|<leader>gb"] = map_callback(function()
				gitsigns.blame_line({ full = true })
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("git: Blame line"),
		-- Text objects
		["ox|ih"] = map_callback(function()
				gitsigns.select_hunk()
			end)
			:with_buffer(bufnr)
			:with_noremap(),
	}
	bind.nvim_load_mapping(map)
end

return M
