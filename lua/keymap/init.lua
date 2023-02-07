local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback

local _lazygit = nil
local function toggle_lazygit()
	if not _lazygit then
		local Terminal = require("toggleterm.terminal").Terminal
		_lazygit = Terminal:new({
			cmd = "lazygit",
			hidden = true,
			direction = "float",
		})
	end
	_lazygit:toggle()
end

local function command_panel()
	local opts = {
		lhs_filter = function(lhs)
			return not string.find(lhs, "Þ")
		end,
		layout_config = {
			width = 0.6,
			height = 0.6,
			prompt_position = "top",
		},
	}
	require("telescope.builtin").keymaps(opts)
end

local plug_map = {
	-- nvim-bufdel
	["n|<A-q>"] = map_cr("BufDel"):with_noremap():with_silent():with_desc("buffer: Close current"),
	-- Bufferline
	["n|gb"] = map_cr("BufferLinePick"):with_noremap():with_silent():with_desc("buffer: Pick"),
	["n|<A-j>"] = map_cr("BufferLineCycleNext"):with_noremap():with_silent():with_desc("buffer: Switch to next"),
	["n|<A-k>"] = map_cr("BufferLineCyclePrev"):with_noremap():with_silent():with_desc("buffer: Switch to prev"),
	["n|<A-S-j>"] = map_cr("BufferLineMoveNext"):with_noremap():with_silent():with_desc("buffer: Move current to next"),
	["n|<A-S-k>"] = map_cr("BufferLineMovePrev"):with_noremap():with_silent():with_desc("buffer: Move current to prev"),
	["n|<leader>be"] = map_cr("BufferLineSortByExtension"):with_noremap():with_desc("buffer: Sort by extension"),
	["n|<leader>bd"] = map_cr("BufferLineSortByDirectory"):with_noremap():with_desc("buffer: Sort by direrctory"),
	["n|<A-1>"] = map_cr("BufferLineGoToBuffer 1"):with_noremap():with_silent():with_desc("buffer: Goto buffer 1"),
	["n|<A-2>"] = map_cr("BufferLineGoToBuffer 2"):with_noremap():with_silent():with_desc("buffer: Goto buffer 2"),
	["n|<A-3>"] = map_cr("BufferLineGoToBuffer 3"):with_noremap():with_silent():with_desc("buffer: Goto buffer 3"),
	["n|<A-4>"] = map_cr("BufferLineGoToBuffer 4"):with_noremap():with_silent():with_desc("buffer: Goto buffer 4"),
	["n|<A-5>"] = map_cr("BufferLineGoToBuffer 5"):with_noremap():with_silent():with_desc("buffer: Goto buffer 5"),
	["n|<A-6>"] = map_cr("BufferLineGoToBuffer 6"):with_noremap():with_silent():with_desc("buffer: Goto buffer 6"),
	["n|<A-7>"] = map_cr("BufferLineGoToBuffer 7"):with_noremap():with_silent():with_desc("buffer: Goto buffer 7"),
	["n|<A-8>"] = map_cr("BufferLineGoToBuffer 8"):with_noremap():with_silent():with_desc("buffer: Goto buffer 8"),
	["n|<A-9>"] = map_cr("BufferLineGoToBuffer 9"):with_noremap():with_silent():with_desc("buffer: Goto buffer 9"),
	-- Lazy.nvim
	["n|<leader>ph"] = map_cr("Lazy"):with_silent():with_noremap():with_nowait():with_desc("package: Show"),
	["n|<leader>ps"] = map_cr("Lazy sync"):with_silent():with_noremap():with_nowait():with_desc("package: Sync"),
	["n|<leader>pu"] = map_cr("Lazy update"):with_silent():with_noremap():with_nowait():with_desc("package: Update"),
	["n|<leader>pi"] = map_cr("Lazy install"):with_silent():with_noremap():with_nowait():with_desc("package: Install"),
	["n|<leader>pl"] = map_cr("Lazy log"):with_silent():with_noremap():with_nowait():with_desc("package: Log"),
	["n|<leader>pc"] = map_cr("Lazy check"):with_silent():with_noremap():with_nowait():with_desc("package: Check"),
	["n|<leader>pd"] = map_cr("Lazy debug"):with_silent():with_noremap():with_nowait():with_desc("package: Debug"),
	["n|<leader>pp"] = map_cr("Lazy profile"):with_silent():with_noremap():with_nowait():with_desc("package: Profile"),
	["n|<leader>pr"] = map_cr("Lazy restore"):with_silent():with_noremap():with_nowait():with_desc("package: Restore"),
	["n|<leader>px"] = map_cr("Lazy clean"):with_silent():with_noremap():with_nowait():with_desc("package: Clean"),
	-- Lsp mapp work when insertenter and lsp start
	["n|<leader>li"] = map_cr("LspInfo"):with_noremap():with_silent():with_nowait():with_desc("lsp: Info"),
	["n|<leader>lr"] = map_cr("LspRestart"):with_noremap():with_silent():with_nowait():with_desc("lsp: Restart"),
	["n|go"] = map_cr("Lspsaga outline"):with_noremap():with_silent():with_desc("lsp: Toggle outline"),
	["n|g["] = map_cr("Lspsaga diagnostic_jump_prev"):with_noremap():with_silent():with_desc("lsp: Prev diagnostic"),
	["n|g]"] = map_cr("Lspsaga diagnostic_jump_next"):with_noremap():with_silent():with_desc("lsp: Next diagnostic"),
	["n|<leader>sl"] = map_cr("Lspsaga show_line_diagnostics")
		:with_noremap()
		:with_silent()
		:with_desc("lsp: Line diagnostic"),
	["n|<leader>sc"] = map_cr("Lspsaga show_cursor_diagnostics")
		:with_noremap()
		:with_silent()
		:with_desc("lsp: Cursor diagnostic"),
	["n|gs"] = map_callback(function()
			vim.lsp.buf.signature_help()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("lsp: Signature help"),
	["n|gr"] = map_cr("Lspsaga rename"):with_noremap():with_silent():with_desc("lsp: Rename in file range"),
	["n|gR"] = map_cr("Lspsaga rename ++project")
		:with_noremap()
		:with_silent()
		:with_desc("lsp: Rename in project range"),
	["n|K"] = map_cr("Lspsaga hover_doc"):with_noremap():with_silent():with_desc("lsp: Show doc"),
	["n|ga"] = map_cr("Lspsaga code_action"):with_noremap():with_silent():with_desc("lsp: Code action for cursor"),
	["v|ga"] = map_cu("Lspsaga code_action"):with_noremap():with_silent():with_desc("lsp: Code action for range"),
	["n|gd"] = map_cr("Lspsaga peek_definition"):with_noremap():with_silent():with_desc("lsp: Preview definition"),
	["n|gD"] = map_cr("Lspsaga goto_definition"):with_noremap():with_silent():with_desc("lsp: Goto definition"),
	["n|gh"] = map_cr("Lspsaga lsp_finder"):with_noremap():with_silent():with_desc("lsp: Show reference"),
	["n|<leader>ci"] = map_cr("Lspsaga incoming_calls")
		:with_noremap()
		:with_silent()
		:with_desc("lsp: Show incoming calls"),
	["n|<leader>co"] = map_cr("Lspsaga outgoing_calls")
		:with_noremap()
		:with_silent()
		:with_desc("lsp: Show outgoing calls"),
	["n|gps"] = map_cr("G push"):with_noremap():with_silent():with_desc("git: Push"),
	["n|gpl"] = map_cr("G pull"):with_noremap():with_silent():with_desc("git: Pull"),
	-- toggleterm
	["t|<Esc><Esc>"] = map_cmd([[<C-\><C-n>]]):with_silent(), -- switch to normal mode in terminal.
	["t|jk"] = map_cmd([[<C-\><C-n>]]):with_silent(), -- switch to normal mode in terminal.
	["n|<C-\\>"] = map_cr([[execute v:count . "ToggleTerm direction=horizontal"]])
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle horizontal"),
	["i|<C-\\>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=horizontal<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle horizontal"),
	["t|<C-\\>"] = map_cmd("<Esc><Cmd>ToggleTerm<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle horizontal"),
	["n|<A-\\>"] = map_cr([[execute v:count . "ToggleTerm direction=vertical"]])
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle vertical"),
	["i|<A-\\>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=vertical<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle vertical"),
	["t|<A-\\>"] = map_cmd("<Esc><Cmd>ToggleTerm<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle vertical"),
	["n|<F5>"] = map_cr([[execute v:count . "ToggleTerm direction=vertical"]])
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle vertical"),
	["i|<F5>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=vertical<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle vertical"),
	["t|<F5>"] = map_cmd("<Esc><Cmd>ToggleTerm<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle vertical"),
	["n|<A-d>"] = map_cr([[execute v:count . "ToggleTerm direction=float"]])
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle float"),
	["i|<A-d>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=float<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle float"),
	["t|<A-d>"] = map_cmd("<Esc><Cmd>ToggleTerm<CR>"):with_noremap():with_silent():with_desc("terminal: Toggle float"),
	["n|<leader>g"] = map_callback(function()
			toggle_lazygit()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("git: Toggle lazygit"),
	["t|<leader>g"] = map_callback(function()
			toggle_lazygit()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("git: Toggle lazygit"),
	["n|<leader>G"] = map_cu("Git"):with_noremap():with_silent():with_desc("git: Open git-fugitive"),
	-- Plugin trouble
	["n|gt"] = map_cr("TroubleToggle"):with_noremap():with_silent():with_desc("lsp: Toggle trouble list"),
	["n|<leader>tr"] = map_cr("TroubleToggle lsp_references")
		:with_noremap()
		:with_silent()
		:with_desc("lsp: Show lsp references"),
	["n|<leader>td"] = map_cr("TroubleToggle document_diagnostics")
		:with_noremap()
		:with_silent()
		:with_desc("lsp: Show document diagnostics"),
	["n|<leader>tw"] = map_cr("TroubleToggle workspace_diagnostics")
		:with_noremap()
		:with_silent()
		:with_desc("lsp: Show workspace diagnostics"),
	["n|<leader>tq"] = map_cr("TroubleToggle quickfix")
		:with_noremap()
		:with_silent()
		:with_desc("lsp: Show quickfix list"),
	["n|<leader>tl"] = map_cr("TroubleToggle loclist"):with_noremap():with_silent():with_desc("lsp: Show loclist"),
	-- Plugin nvim-tree
	["n|<C-n>"] = map_cr("NvimTreeToggle"):with_noremap():with_silent():with_desc("filetree: Toggle"),
	["n|<leader>nf"] = map_cr("NvimTreeFindFile"):with_noremap():with_silent():with_desc("filetree: Find file"),
	["n|<leader>nr"] = map_cr("NvimTreeRefresh"):with_noremap():with_silent():with_desc("filetree: Refresh"),
	-- Plugin Telescope
	["n|<leader>u"] = map_callback(function()
			require("telescope").extensions.undo.undo()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("editn: Show undo history"),
	["n|<leader>fp"] = map_callback(function()
			require("telescope").extensions.projects.projects({})
		end)
		:with_noremap()
		:with_silent()
		:with_desc("find: Project"),
	["n|<leader>fr"] = map_callback(function()
			require("telescope").extensions.frecency.frecency()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("find: File by frecency"),
	["n|<leader>fw"] = map_callback(function()
			require("telescope").extensions.live_grep_args.live_grep_args()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("find: Word in project"),
	["n|<leader>fe"] = map_cu("Telescope oldfiles"):with_noremap():with_silent():with_desc("find: File by history"),
	["n|<leader>ff"] = map_cu("Telescope find_files"):with_noremap():with_silent():with_desc("find: File in project"),
	["n|<leader>fc"] = map_cu("Telescope colorscheme")
		:with_noremap()
		:with_silent()
		:with_desc("ui: Change colorscheme for current session"),
	["n|<leader>fn"] = map_cu(":enew"):with_noremap():with_silent():with_desc("buffer: New"),
	["n|<leader>fg"] = map_cu("Telescope git_files")
		:with_noremap()
		:with_silent()
		:with_desc("find: file in git project"),
	["n|<leader>fz"] = map_cu("Telescope zoxide list")
		:with_noremap()
		:with_silent()
		:with_desc("editn: Change current direrctory by zoxide"),
	["n|<leader>fb"] = map_cu("Telescope buffers"):with_noremap():with_silent():with_desc("find: Buffer opened"),
	-- Plugin accelerate-jk
	["n|j"] = map_callback(function()
		return vim.api.nvim_replace_termcodes("<Plug>(accelerated_jk_gj)", true, true, true)
	end):with_expr(),
	["n|k"] = map_callback(function()
		return vim.api.nvim_replace_termcodes("<Plug>(accelerated_jk_gk)", true, true, true)
	end):with_expr(),
	-- Plugin vim-eft
	["n|;"] = map_callback(function()
		return vim.api.nvim_replace_termcodes("<Plug>(clever-f-repeat-forward)", true, true, true)
	end):with_expr(),
	["n|,"] = map_callback(function()
		return vim.api.nvim_replace_termcodes("<Plug>(clever-f-repeat-back)", true, true, true)
	end):with_expr(),
	-- Plugin Hop
	["n|<leader>w"] = map_cu("HopWord"):with_noremap():with_desc("jump: Goto word"),
	["n|<leader>j"] = map_cu("HopLine"):with_noremap():with_desc("jump: Goto line"),
	["n|<leader>k"] = map_cu("HopLine"):with_noremap():with_desc("jump: Goto line"),
	["n|<leader>c"] = map_cu("HopChar1"):with_noremap():with_desc("jump: Goto one char"),
	["n|<leader>cc"] = map_cu("HopChar2"):with_noremap():with_desc("jump: Goto two chars"),
	-- Plugin EasyAlign
	["n|gea"] = map_callback(function()
			return vim.api.nvim_replace_termcodes("<Plug>(EasyAlign)", true, true, true)
		end)
		:with_expr()
		:with_desc("editn: Align with delimiter"),
	["x|gea"] = map_callback(function()
			return vim.api.nvim_replace_termcodes("<Plug>(EasyAlign)", true, true, true)
		end)
		:with_expr()
		:with_desc("editx: Align with delimiter"),
	-- Plugin MarkdownPreview
	["n|<F12>"] = map_cr("MarkdownPreviewToggle"):with_noremap():with_silent():with_desc("tool: Preview markdown"),
	-- Plugin auto_session
	["n|<leader>ss"] = map_cu("SaveSession"):with_noremap():with_silent():with_desc("session: Save"),
	["n|<leader>sr"] = map_cu("RestoreSession"):with_noremap():with_silent():with_desc("session: Restore"),
	["n|<leader>sd"] = map_cu("DeleteSession"):with_noremap():with_silent():with_desc("session: Delete"),
	-- Plugin SnipRun
	["v|<leader>r"] = map_cr("SnipRun"):with_noremap():with_silent():with_desc("tool: Run code by range"),
	["n|<leader>r"] = map_cu([[%SnipRun]]):with_noremap():with_silent():with_desc("tool: Run code by file"),
	-- Plugin dap
	["n|<F6>"] = map_callback(function()
			require("dap").continue()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Run/Continue"),
	["n|<F7>"] = map_callback(function()
			require("dap").terminate()
			require("dapui").close()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Stop"),
	["n|<F8>"] = map_callback(function()
			require("dap").toggle_breakpoint()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Toggle breakpoint"),
	["n|<F9>"] = map_callback(function()
			require("dap").step_into()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Step into"),
	["n|<F10>"] = map_callback(function()
			require("dap").step_out()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Step out"),
	["n|<F11>"] = map_callback(function()
			require("dap").step_over()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Step over"),
	["n|<leader>db"] = map_callback(function()
			require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Set breakpoint with condition"),
	["n|<leader>dc"] = map_callback(function()
			require("dap").run_to_cursor()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Run to cursor"),
	["n|<leader>dl"] = map_callback(function()
			require("dap").run_last()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Run last"),
	["n|<leader>do"] = map_callback(function()
			require("dap").repl.open()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("debug: Open REPL"),
	["o|m"] = map_callback(function()
		require("tsht").nodes()
	end):with_silent(),
	-- Plugin Diffview
	["n|<leader>D"] = map_cr("DiffviewOpen"):with_silent():with_noremap():with_desc("git: Show diff"),
	["n|<leader><leader>D"] = map_cr("DiffviewClose"):with_silent():with_noremap():with_desc("git: Close diff"),
	["n|<C-p>"] = map_callback(command_panel):with_silent():with_noremap():with_desc("tool: Toggle command panel"),
	-- Plugin Tabout
	["i|<A-l>"] = map_cmd("<Plug>(TaboutMulti)"):with_silent():with_noremap():with_desc("editi: Goto end of pair"),
	["i|<A-h>"] = map_cmd("<Plug>(TaboutBackMulti)")
		:with_silent()
		:with_noremap()
		:with_desc("editi: Goto begin of pair"),
}

bind.nvim_load_mapping(plug_map)
