local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback

local plug_map = {
	["n|<A-f>"] = map_cmd("<Cmd>FormatToggle<CR>"):with_noremap():with_desc("Formater: Toggle format on save"),
}
bind.nvim_load_mapping(plug_map)

local mapping = {}
local hide_diagnostic = function()
	if vim.g.diagnostics_active then
		vim.g.diagnostics_active = false
		vim.diagnostic.disable()
	else
		vim.g.diagnostics_active = true
		vim.diagnostic.enable()
	end
end

function mapping.lsp(buf)
	local map = {
		-- LSP-related keymaps, work only when event = { "InsertEnter", "LspStart" }
		["n|<leader>li"] = map_cr("LspInfo"):with_buffer(buf):with_desc("lsp: Info"),
		["n|<leader>lr"] = map_cr("LspRestart"):with_buffer(buf):with_nowait():with_desc("lsp: Restart"),
		["n|<leader>gf"] = map_cr("Lspsaga lsp_finder"):with_buffer(buf):with_desc("lsp: Toggle finder"),
		["n|<leader>gp"] = map_cr("Lspsaga peek_definition"):with_buffer(buf):with_desc("lsp: Preview definition"),
		["n|<leader>gi"] = map_cr("Lspsaga incoming_calls"):with_buffer(buf):with_desc("lsp: Show incoming calls"),
		["n|<leader>go"] = map_cr("Lspsaga outgoing_calls"):with_buffer(buf):with_desc("lsp: Show outgoing calls"),
		["n|<leader>ca"] = map_cr("Lspsaga code_action"):with_buffer(buf):with_desc("lsp: Code action for cursor"),
		["n|<leader>ld"] = map_cr("Lspsaga show_line_diagnostics ++unfocus")
			:with_buffer(buf)
			:with_desc("lsp: Line diagnostic"),
		["n|<TAB>"] = map_cr(":lua vim.lsp.buf.hover()<CR>"):with_buffer(buf):with_desc("lsp: Toggle hover"),
		["n|K"] = map_cr("lua vim.lsp.buf.hover()"):with_buffer(buf):with_desc("lsp: Show doc"),
		["n|<leader>rn"] = map_cmd("<cmd>lua vim.lsp.buf.rename()<CR>"):with_buffer(buf):with_desc("lsp: Rename"),
		["n|gr"] = map_cmd("<cmd>lua vim.lsp.buf.rename()<CR>"):with_buffer(buf):with_desc("lsp: Rename"),
		["n|<leader>hd"] = map_callback(hide_diagnostic):with_buffer(buf):with_desc("lsp: Toggle hide diagnostic"),
		["i|<c-s>"] = map_callback(function()
			vim.lsp.buf.signature_help()
		end):with_desc("lsp: Signature help"),
		["n|gd"] = map_cmd("<cmd>lua vim.lsp.buf.definition()<CR>"):with_buffer(buf):with_desc("lsp: Goto definition"),
		["n|gq"] = map_cmd("<cmd>lua vim.diagnostic.setqflist()<CR>")
			:with_buffer(buf)
			:with_desc("lsp: Toggle diagnostic quickfix"),
		["n|gh"] = map_cmd("<cmd>lua vim.lsp.buf.references()<CR>"):with_buffer(buf):with_desc("lsp: Goto references"),
		["n|]d"] = map_cr('<cmd>lua vim.diagnostic.goto_next({ popup_opts = { border = "single" }})<CR>')
			:with_buffer(buf)
			:with_desc("lsp: Goto next diagnostic"),
		["n|[d"] = map_cr('<cmd>lua vim.diagnostic.goto_prev({ popup_opts = { border = "single" }})<CR>')
			:with_buffer(buf)
			:with_desc("lsp: Goto prev diagnostic"),
	}
	bind.nvim_load_mapping(map)
end

return mapping
