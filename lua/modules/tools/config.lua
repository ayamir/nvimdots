local config = {}

function config.telescope()
	vim.api.nvim_command([[packadd sqlite.lua]])
	vim.api.nvim_command([[packadd project.nvim]])
	vim.api.nvim_command([[packadd telescope-fzf-native.nvim]])
	vim.api.nvim_command([[packadd telescope-frecency.nvim]])
	vim.api.nvim_command([[packadd telescope-zoxide]])
	vim.api.nvim_command([[packadd telescope-live-grep-args.nvim]])
	vim.api.nvim_command([[packadd telescope-undo.nvim]])

	local icons = { ui = require("modules.ui.icons").get("ui", true) }
	local telescope_actions = require("telescope.actions.set")
	local fixfolds = {
		hidden = true,
		attach_mappings = function(_)
			telescope_actions.select:enhance({
				post = function()
					vim.api.nvim_command([[:normal! zx"]])
				end,
			})
			return true
		end,
	}
	local lga_actions = require("telescope-live-grep-args.actions")

	require("telescope").setup({
		defaults = {
			initial_mode = "insert",
			prompt_prefix = " " .. icons.ui.Telescope .. " ",
			selection_caret = icons.ui.ChevronRight,
			entry_prefix = " ",
			scroll_strategy = "limit",
			results_title = false,
			layout_strategy = "horizontal",
			path_display = { "absolute" },
			file_ignore_patterns = { ".git/", ".cache", "%.class", "%.pdf", "%.mkv", "%.mp4", "%.zip" },
			layout_config = {
				horizontal = {
					preview_width = 0.5,
				},
			},
			file_previewer = require("telescope.previewers").vim_buffer_cat.new,
			grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
			qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
			file_sorter = require("telescope.sorters").get_fuzzy_file,
			generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
		},
		extensions = {
			fzf = {
				fuzzy = false,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
			frecency = {
				show_scores = true,
				show_unindexed = true,
				ignore_patterns = { "*.git/*", "*/tmp/*" },
			},
			live_grep_args = {
				auto_quoting = true, -- enable/disable auto-quoting
				-- define mappings, e.g.
				mappings = { -- extend mappings
					i = {
						["<C-k>"] = lga_actions.quote_prompt(),
						["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
					},
				},
			},
			undo = {
				side_by_side = true,
				layout_config = {
					preview_height = 0.8,
				},
				mappings = { -- this whole table is the default
					i = {
						-- IMPORTANT: Note that telescope-undo must be available when telescope is configured if
						-- you want to use the following actions. This means installing as a dependency of
						-- telescope in it's `requirements` and loading this extension from there instead of
						-- having the separate plugin definition as outlined above. See issue #6.
						["<cr>"] = require("telescope-undo.actions").yank_additions,
						["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
						["<C-cr>"] = require("telescope-undo.actions").restore,
					},
				},
			},
		},
		pickers = {
			buffers = fixfolds,
			find_files = fixfolds,
			git_files = fixfolds,
			grep_string = fixfolds,
			live_grep = fixfolds,
			oldfiles = fixfolds,
		},
	})

	require("telescope").load_extension("notify")
	require("telescope").load_extension("fzf")
	require("telescope").load_extension("projects")
	require("telescope").load_extension("zoxide")
	require("telescope").load_extension("frecency")
	require("telescope").load_extension("live_grep_args")
	require("telescope").load_extension("undo")
end

function config.project()
	require("project_nvim").setup({
		manual_mode = false,
		detection_methods = { "lsp", "pattern" },
		patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
		ignore_lsp = { "efm", "copilot" },
		exclude_dirs = {},
		show_hidden = false,
		silent_chdir = true,
		scope_chdir = "global",
		datapath = vim.fn.stdpath("data"),
	})
end

function config.trouble()
	local icons = {
		ui = require("modules.ui.icons").get("ui"),
		diagnostics = require("modules.ui.icons").get("diagnostics"),
	}

	require("trouble").setup({
		position = "bottom", -- position of the list can be: bottom, top, left, right
		height = 10, -- height of the trouble list when position is top or bottom
		width = 50, -- width of the list when position is left or right
		icons = true, -- use devicons for filenames
		mode = "document_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
		fold_open = icons.ui.ArrowOpen, -- icon used for open folds
		fold_closed = icons.ui.ArrowClosed, -- icon used for closed folds
		group = true, -- group results by file
		padding = true, -- add an extra new line on top of the list
		action_keys = {
			-- key mappings for actions in the trouble list
			-- map to {} to remove a mapping, for example:
			-- close = {},
			close = "q", -- close the list
			cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
			refresh = "r", -- manually refresh
			jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
			open_split = { "<c-x>" }, -- open buffer in new split
			open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
			open_tab = { "<c-t>" }, -- open buffer in new tab
			jump_close = { "o" }, -- jump to the diagnostic and close the list
			toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
			toggle_preview = "P", -- toggle auto_preview
			hover = "K", -- opens a small popup with the full multiline message
			preview = "p", -- preview the diagnostic location
			close_folds = { "zM", "zm" }, -- close all folds
			open_folds = { "zR", "zr" }, -- open all folds
			toggle_fold = { "zA", "za" }, -- toggle fold of current file
			previous = "k", -- preview item
			next = "j", -- next item
		},
		indent_lines = true, -- add an indent guide below the fold icons
		auto_open = false, -- automatically open the list when you have diagnostics
		auto_close = false, -- automatically close the list when you have no diagnostics
		auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
		auto_fold = false, -- automatically fold a file trouble list at creation
		auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
		signs = {
			-- icons / text used for a diagnostic
			error = icons.diagnostics.Error_alt,
			warning = icons.diagnostics.Warning_alt,
			hint = icons.diagnostics.Hint_alt,
			information = icons.diagnostics.Information_alt,
			other = icons.diagnostics.Question_alt,
		},
		use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
	})
end

function config.sniprun()
	require("sniprun").setup({
		selected_interpreters = {}, -- " use those instead of the default for the current filetype
		repl_enable = {}, -- " enable REPL-like behavior for the given interpreters
		repl_disable = {}, -- " disable REPL-like behavior for the given interpreters
		interpreter_options = {}, -- " intepreter-specific options, consult docs / :SnipInfo <name>
		-- " you can combo different display modes as desired
		display = {
			"Classic", -- "display results in the command-line  area
			"VirtualTextOk", -- "display ok results as virtual text (multiline is shortened)
			"VirtualTextErr", -- "display error results as virtual text
			-- "TempFloatingWindow",      -- "display results in a floating window
			"LongTempFloatingWindow", -- "same as above, but only long results. To use with VirtualText__
			-- "Terminal"                 -- "display results in a vertical split
		},
		-- " miscellaneous compatibility/adjustement settings
		inline_messages = 0, -- " inline_message (0/1) is a one-line way to display messages
		-- " to workaround sniprun not being able to display anything

		borders = "shadow", -- " display borders around floating windows
		-- " possible values are 'none', 'single', 'double', or 'shadow'
	})
end

function config.wilder()
	local wilder = require("wilder")
	local icons = { ui = require("modules.ui.icons").get("ui") }

	wilder.setup({ modes = { ":", "/", "?" } })
	wilder.set_option("use_python_remote_plugin", 0)
	wilder.set_option("pipeline", {
		wilder.branch(
			wilder.cmdline_pipeline({ use_python = 0, fuzzy = 1, fuzzy_filter = wilder.lua_fzy_filter() }),
			wilder.vim_search_pipeline(),
			{
				wilder.check(function(_, x)
					return x == ""
				end),
				wilder.history(),
				wilder.result({
					draw = {
						function(_, x)
							return icons.ui.Calendar .. " " .. x
						end,
					},
				}),
			}
		),
	})

	local match_hl = require("modules.utils").hlToRgb("String", false, "#ABE9B3")

	local popupmenu_renderer = wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
		border = "rounded",
		highlights = {
			border = "Title", -- highlight to use for the border
			accent = wilder.make_hl("WilderAccent", "Pmenu", { { a = 0 }, { a = 0 }, { foreground = match_hl } }),
		},
		empty_message = wilder.popupmenu_empty_message_with_spinner(),
		highlighter = wilder.lua_fzy_highlighter(),
		left = {
			" ",
			wilder.popupmenu_devicons(),
			wilder.popupmenu_buffer_flags({
				flags = " a + ",
				icons = { ["+"] = icons.ui.Pencil, a = icons.ui.Indicator, h = icons.ui.File },
			}),
		},
		right = {
			" ",
			wilder.popupmenu_scrollbar(),
		},
	}))
	local wildmenu_renderer = wilder.wildmenu_renderer({
		highlighter = wilder.lua_fzy_highlighter(),
		apply_incsearch_fix = true,
	})
	wilder.set_option(
		"renderer",
		wilder.renderer_mux({
			[":"] = popupmenu_renderer,
			["/"] = wildmenu_renderer,
			substitute = wildmenu_renderer,
		})
	)
end

function config.which_key()
	local icons = {
		ui = require("modules.ui.icons").get("ui"),
		misc = require("modules.ui.icons").get("misc"),
	}

	require("which-key").setup({
		plugins = {
			presets = {
				operators = false,
				motions = false,
				text_objects = false,
				windows = false,
				nav = false,
				z = true,
				g = true,
			},
		},

		icons = {
			breadcrumb = icons.ui.Separator,
			separator = icons.misc.Vbar,
			group = icons.misc.Add,
		},

		window = {
			border = "none",
			position = "bottom",
			margin = { 1, 0, 1, 0 },
			padding = { 1, 1, 1, 1 },
			winblend = 0,
		},
	})
end

function config.legendary()
	require("legendary").setup({
		which_key = {
			auto_register = true,
			do_binding = false,
		},
		scratchpad = {
			view = "float",
			results_view = "float",
			keep_contents = true,
		},
		sort = {
			-- sort most recently used item to the top
			most_recent_first = true,
			-- sort user-defined items before built-in items
			user_items_first = true,
			frecency = {
				-- the directory to store the database in
				db_root = string.format("%s/legendary/", vim.fn.stdpath("data")),
				-- the maximum number of timestamps for a single item
				-- to store in the database
				max_timestamps = 10,
			},
		},
		-- Directory used for caches
		cache_path = string.format("%s/legendary/", vim.fn.stdpath("cache")),
		-- Log level, one of 'trace', 'debug', 'info', 'warn', 'error', 'fatal'
		log_level = "info",
	})

	require("which-key").register({
		["<leader>"] = {
			b = {
				name = "Bufferline commands",
				d = "buffer: Sort by directory",
				e = "buffer: Sort by extension",
			},

			d = {
				name = "Dap commands",
				b = "debug: Toggle breakpoint",
				d = "debug: Terminate debug session",
				r = "debug: Continue",
				l = "debug: Open repl",
				i = "debug: Step in",
				o = "debug: Step out",
				v = "debug: Step over",
			},
			f = {
				name = "Telescope commands",
				p = "find: Project",
				w = "find: Word",
				r = "find: File by frecency",
				e = "find: File by history",
				c = "ui: Change color scheme",
				z = "edit: Change current directory by zoxide",
				f = "find: File under current work directory",
				g = "find: File under current git directory",
				n = "edit: New file",
				b = "find: Buffer opened",
			},
			h = {
				name = "Gitsigns commands",
				b = "git: Blame line",
				p = "git: Preview hunk",
				s = "git: Stage hunk",
				u = "git: Undo stage hunk",
				r = "git: Reset hunk",
				R = "git: Reset buffer",
			},
			l = {
				name = "LSP commands",
				i = "lsp: LSP Info",
				r = "lsp: LSP Restart",
			},
			n = {
				name = "NvimTree commands",
				f = "filetree: NvimTree find file",
				r = "filetree: NvimTree refresh",
			},
			p = {
				name = "Packer commands",
				s = "packer: PackerSync",
				i = "packer: PackerInstall",
				c = "packer: PackerClean",
				u = "packer: PackerUpdate",
			},
			s = {
				name = "Session commands",
				s = "sesson: Save session",
				r = "sesson: Restore session",
				d = "sesson: Delete session",
			},
			t = {
				name = "Trouble commands",
				d = "lsp: Show document diagnostics",
				w = "lsp: Show workspace diagnostics",
				q = "lsp: Show quickfix list",
				l = "lsp: Show loclist",
			},
		},
		["g"] = {
			a = "lsp: Code action",
			d = "lsp: Preview definition",
			D = "lsp: Goto definition",
			h = "lsp: Show reference",
			o = "lsp: Toggle outline",
			r = "lsp: Rename",
			s = "lsp: Signature help",
			t = "lsp: Toggle trouble list",
			b = "buffer: Buffer pick",
			p = {
				name = "git commands",
				s = "git: Push",
				l = "git: Pull",
			},
		},
		["<leader>G"] = "git: Show fugitive",
		["<leader>g"] = "git: Show lazygit",
		["<leader>D"] = "git: Show diff",
		["<leader><leader>D"] = "git: Close diff",
		["]g"] = "git: Goto next hunk",
		["[g"] = "git: Goto prev hunk",
		["g["] = "lsp: Goto prev diagnostic",
		["g]"] = "lsp: Goto next diagnostic",
		["<leader>w"] = "jump: Goto word",
		["<leader>j"] = "jump: Goto line",
		["<leader>k"] = "jump: Goto line",
		["<leader>c"] = "jump: Goto one char",
		["<leader>cc"] = "jump: Goto two chars",
		["<leader>o"] = "edit: Check spell",
		["<leader>u"] = "edit: Show undo history",
		["<leader>r"] = "tool: Code snip run",
		["<F12>"] = "tool: Markdown preview",
	})
end

function config.dressing()
	require("dressing").setup({
		input = {
			enabled = true,
		},
		select = {
			enabled = true,
			backend = "telescope",
			trim_prompt = true,
		},
	})
end

return config
