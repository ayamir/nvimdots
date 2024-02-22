local bind = require("keymap.bind")
local map_cu = bind.map_cu
local map_callback = bind.map_callback
local map_cr = bind.map_cr
return {
	-- Plugin: nvim-tree
	["n|<leader>e"] = map_cr("NvimTreeToggle"):with_noremap():with_silent():with_desc("filetree: Toggle"),
	-- Plugin: telescope
	["n|<leader>fk"] = map_callback(function()
			_command_panel()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("tool: Toggle command panel"),

	["n|<leader>ui"] = map_cu("Telescope colorscheme"):with_noremap():with_silent():with_desc("ui: Change colorscheme for current session"),
	["n|<leader>d"] = map_callback(function()
			require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Info"),
	["n|<leader>f"] = map_cu("telescope colorscheme"):with_noremap():with_silent():with_desc("find: Info"),
	["n|<leader>n"] = map_cr("NvimTreeFindFile"):with_noremap():with_silent():with_desc("filetree: Info"),
	["n|<leader>p"] = map_cr("Lazy"):with_silent():with_noremap():with_nowait():with_desc("Lazy: Show"),
	["n|<leader>s"] = map_cu("SessionSave"):with_noremap():with_silent():with_desc("session: Info"),
	["n|<leader>t"] = map_cr("TroubleToggle lsp_references"):with_noremap():with_silent():with_desc("lsp: Trouble"),
}
