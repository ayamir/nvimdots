local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
local et = bind.escape_termcode

local mappings = {
	builtins = {
		-- Builtins: Save & Quit
		["n|<C-s>"] = map_cu("write"):with_noremap():with_silent():with_desc("edit: Save file"),
		["n|<C-q>"] = map_cr("wq"):with_desc("edit: Save file and quit"),
		["n|<A-S-q>"] = map_cr("q!"):with_desc("edit: Force quit"),

		-- Builtins: Insert mode
		["i|<C-u>"] = map_cmd("<C-G>u<C-U>"):with_noremap():with_desc("edit: Delete previous block"),
		["i|<C-b>"] = map_cmd("<Left>"):with_noremap():with_desc("edit: Move cursor to left"),
		["i|<C-a>"] = map_cmd("<ESC>^i"):with_noremap():with_desc("edit: Move cursor to line start"),
		["i|<C-s>"] = map_cmd("<Esc>:w<CR>"):with_desc("edit: Save file"),
		["i|<C-q>"] = map_cmd("<Esc>:wq<CR>"):with_desc("edit: Save file and quit"),

		-- Builtins: Command mode
		["c|<C-b>"] = map_cmd("<Left>"):with_noremap():with_desc("edit: Left"),
		["c|<C-f>"] = map_cmd("<Right>"):with_noremap():with_desc("edit: Right"),
		["c|<C-a>"] = map_cmd("<Home>"):with_noremap():with_desc("edit: Home"),
		["c|<C-e>"] = map_cmd("<End>"):with_noremap():with_desc("edit: End"),
		["c|<C-d>"] = map_cmd("<Del>"):with_noremap():with_desc("edit: Delete"),
		["c|<C-h>"] = map_cmd("<BS>"):with_noremap():with_desc("edit: Backspace"),
		["c|<C-t>"] = map_cmd([[<C-R>=expand("%:p:h") . "/" <CR>]])
			:with_noremap()
			:with_desc("edit: Complete path of current file"),

		-- Builtins: Visual mode
		["v|J"] = map_cmd(":m '>+1<CR>gv=gv"):with_desc("edit: Move this line down"),
		["v|K"] = map_cmd(":m '<-2<CR>gv=gv"):with_desc("edit: Move this line up"),
		["v|<"] = map_cmd("<gv"):with_desc("edit: Decrease indent"),
		["v|>"] = map_cmd(">gv"):with_desc("edit: Increase indent"),

		-- Builtins: "Suckless" - named after r/suckless
		["n|Y"] = map_cmd("y$"):with_desc("edit: Yank text to EOL"),
		["n|D"] = map_cmd("d$"):with_desc("edit: Delete text to EOL"),
		["n|n"] = map_cmd("nzzzv"):with_noremap():with_desc("edit: Next search result"),
		["n|N"] = map_cmd("Nzzzv"):with_noremap():with_desc("edit: Prev search result"),
		["n|J"] = map_cmd("mzJ`z"):with_noremap():with_desc("edit: Join next line"),
		["n|<S-Tab>"] = map_cr("normal za"):with_noremap():with_silent():with_desc("edit: Toggle code fold"),
		["n|<Esc>"] = map_callback(function()
				_flash_esc_or_noh()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("edit: Clear search highlight"),
		["n|<leader>o"] = map_cr("setlocal spell! spelllang=en_us"):with_desc("edit: Toggle spell check"),
	},
	plugins = {
		-- Plugin: persisted.nvim
		["n|<leader>ss"] = map_cu("SessionSave"):with_noremap():with_silent():with_desc("session: Save"),
		["n|<leader>sl"] = map_cu("SessionLoad"):with_noremap():with_silent():with_desc("session: Load current"),
		["n|<leader>sd"] = map_cu("SessionDelete"):with_noremap():with_silent():with_desc("session: Delete"),

		-- Plugin: comment.nvim
		["n|gcc"] = map_callback(function()
				return vim.v.count == 0 and et("<Plug>(comment_toggle_linewise_current)")
					or et("<Plug>(comment_toggle_linewise_count)")
			end)
			:with_silent()
			:with_noremap()
			:with_expr()
			:with_desc("edit: Toggle comment for line"),
		["n|gbc"] = map_callback(function()
				return vim.v.count == 0 and et("<Plug>(comment_toggle_blockwise_current)")
					or et("<Plug>(comment_toggle_blockwise_count)")
			end)
			:with_silent()
			:with_noremap()
			:with_expr()
			:with_desc("edit: Toggle comment for block"),
		["n|gc"] = map_cmd("<Plug>(comment_toggle_linewise)")
			:with_silent()
			:with_noremap()
			:with_desc("edit: Toggle comment for line with operator"),
		["n|gb"] = map_cmd("<Plug>(comment_toggle_blockwise)")
			:with_silent()
			:with_noremap()
			:with_desc("edit: Toggle comment for block with operator"),
		["x|gc"] = map_cmd("<Plug>(comment_toggle_linewise_visual)")
			:with_silent()
			:with_noremap()
			:with_desc("edit: Toggle comment for line with selection"),
		["x|gb"] = map_cmd("<Plug>(comment_toggle_blockwise_visual)")
			:with_silent()
			:with_noremap()
			:with_desc("edit: Toggle comment for block with selection"),

		-- Plugin: diffview.nvim
		["n|<leader>gd"] = map_cr("DiffviewOpen"):with_silent():with_noremap():with_desc("git: Show diff"),
		["n|<leader>gD"] = map_cr("DiffviewClose"):with_silent():with_noremap():with_desc("git: Close diff"),

		-- Plugin: hop.nvim
		["nv|<leader>w"] = map_cmd("<Cmd>HopWordMW<CR>"):with_noremap():with_desc("jump: Goto word"),
		["nv|<leader>j"] = map_cmd("<Cmd>HopLineMW<CR>"):with_noremap():with_desc("jump: Goto line"),
		["nv|<leader>k"] = map_cmd("<Cmd>HopLineMW<CR>"):with_noremap():with_desc("jump: Goto line"),
		["nv|<leader>c"] = map_cmd("<Cmd>HopChar1MW<CR>"):with_noremap():with_desc("jump: Goto one char"),
		["nv|<leader>C"] = map_cmd("<Cmd>HopChar2MW<CR>"):with_noremap():with_desc("jump: Goto two chars"),

		-- Plugin: nvim-spectre
		["n|<leader>Ss"] = map_callback(function()
				require("spectre").toggle()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editn: Toggle search & replace panel"),
		["n|<leader>Sp"] = map_callback(function()
				require("spectre").open_visual({ select_word = true })
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editn: search&replace current word (project)"),
		["v|<leader>Sp"] = map_callback(function()
				require("spectre").open_visual()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("edit: search & replace current word (project)"),
		["n|<leader>Sf"] = map_callback(function()
				require("spectre").open_file_search({ select_word = true })
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editn: search & replace current word (file)"),

		-- Plugin: nvim-treehopper
		["o|m"] = map_cu("lua require('tsht').nodes()"):with_silent():with_desc("jump: Operate across syntax tree"),

		-- Plugin: suda.vim
		["n|<A-s>"] = map_cu("SudaWrite"):with_silent():with_noremap():with_desc("editn: Save file using sudo"),
	},
}

bind.nvim_load_mapping(mappings.builtins)
bind.nvim_load_mapping(mappings.plugins)
