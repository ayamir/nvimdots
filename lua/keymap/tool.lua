local vim_path = require("core.global").vim_path
local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
require("keymap.helpers")

local mappings = {
	plugins = {
		-- Plugin: vim-fugitive
		["n|gps"] = map_cr("G push"):with_noremap():with_silent():with_desc("git: Push"),
		["n|gpl"] = map_cr("G pull"):with_noremap():with_silent():with_desc("git: Pull"),
		["n|<leader>gG"] = map_cu("Git"):with_noremap():with_silent():with_desc("git: Open git-fugitive"),

		-- Plugin: edgy
		["n|<C-n>"] = map_callback(function()
				require("edgy").toggle("left")
			end)
			:with_noremap()
			:with_silent()
			:with_desc("filetree: Toggle"),

		-- Plugin: nvim-tree
		["n|<leader>nf"] = map_cr("NvimTreeFindFile"):with_noremap():with_silent():with_desc("filetree: Find file"),
		["n|<leader>nr"] = map_cr("NvimTreeRefresh"):with_noremap():with_silent():with_desc("filetree: Refresh"),

		-- Plugin: sniprun
		["v|<leader>r"] = map_cr("SnipRun"):with_noremap():with_silent():with_desc("tool: Run code by range"),
		["n|<leader>r"] = map_cu([[%SnipRun]]):with_noremap():with_silent():with_desc("tool: Run code by file"),

		-- Plugin: toggleterm
		["t|<Esc><Esc>"] = map_cmd([[<C-\><C-n>]]):with_noremap():with_silent(), -- switch to normal mode in terminal.
		["n|<leader>gg"] = map_callback(function()
				require("nvchad.term").toggle({ pos = "float", cmd = "lazygit" })
			end)
			:with_noremap()
			:with_silent()
			:with_desc("git: Toggle lazygit"),

		-- Plugin: trouble
		["n|gt"] = map_cr("Trouble diagnostics toggle")
			:with_noremap()
			:with_silent()
			:with_desc("lsp: Toggle trouble list"),
		["n|<leader>lw"] = map_cr("Trouble diagnostics toggle")
			:with_noremap()
			:with_silent()
			:with_desc("lsp: Show workspace diagnostics"),
		["n|<leader>lp"] = map_cr("Trouble project_diagnostics toggle")
			:with_noremap()
			:with_silent()
			:with_desc("lsp: Show project diagnostics"),
		["n|<leader>ld"] = map_cr("Trouble diagnostics toggle filter.buf=0")
			:with_noremap()
			:with_silent()
			:with_desc("lsp: Show document diagnostics"),

		-- Plugin: telescope
		["n|<C-p>"] = map_callback(function()
				_command_panel()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Toggle command panel"),
		["n|<leader>fc"] = map_callback(function()
				_telescope_collections()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Open Telescope collections"),
		["n|<leader>ff"] = map_callback(function()
				require("search").open({ collection = "file" })
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Find files"),
		["n|<leader>fp"] = map_callback(function()
				require("search").open({ collection = "pattern" })
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Find patterns"),
		["v|<leader>fs"] = map_callback(function()
				local opts = vim.fn.getcwd() == vim_path and { additional_args = { "--no-ignore" } } or {}
				require("telescope-live-grep-args.shortcuts").grep_visual_selection(opts)
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Find word under cursor"),
		["n|<leader>fg"] = map_callback(function()
				require("search").open({ collection = "git" })
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Locate Git objects"),
		["n|<leader>fd"] = map_callback(function()
				require("search").open({ collection = "dossier" })
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Retrieve dossiers"),
		["n|<leader>fm"] = map_callback(function()
				require("search").open({ collection = "misc" })
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Miscellaneous"),
		["n|<leader>ft"] = map_callback(function()
				require("nvchad.themes").open()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Miscellaneous"),

		-- Plugin: dap
		["n|<F6>"] = map_callback(function()
				require("dap").continue()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("debug: Run/Continue"),
		["n|<F7>"] = map_callback(function()
				require("dap").terminate()
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
	},
}
-- set toggle mapping for n/i/t mode
local modes = { "n", "i", "t" }
for _, mode in pairs(modes) do
	mappings.plugins[string.format("%s|<C-\\>", mode)] = map_callback(function()
			require("nvchad.term").toggle({ pos = "sp", id = "HorizontalTerm" })
		end)
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle horizontal")
	mappings.plugins[string.format("%s|<A-\\>", mode)] = map_callback(function()
			require("nvchad.term").toggle({ pos = "vsp", id = "VerticalTerm" })
		end)
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle vertical")
	mappings.plugins[string.format("%s|<F5>", mode)] = map_callback(function()
			require("nvchad.term").toggle({ pos = "vsp", id = "VerticalTerm" })
		end)
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle vertical")
	mappings.plugins[string.format("%s|<A-d>", mode)] = map_callback(function()
			require("nvchad.term").toggle({ pos = "float", id = "FloatTerm" })
		end)
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle float")
end

bind.nvim_load_mapping(mappings.plugins)
