return function()
	local icons = { ui = require("modules.utils.icons").get("ui", true) }
	local lga_actions = require("telescope-live-grep-args.actions")

	require("modules.utils").load_plugin("telescope", {
		defaults = {
			vimgrep_arguments = {
				"rg",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
			},
			initial_mode = "insert",
			prompt_prefix = " " .. icons.ui.Telescope .. " ",
			selection_caret = icons.ui.ChevronRight,
			scroll_strategy = "limit",
			results_title = false,
			layout_strategy = "horizontal",
			path_display = { "absolute" },
			selection_strategy = "reset",
			sorting_strategy = "ascending",
			color_devicons = true,
			file_ignore_patterns = { ".git/", ".cache", "build/", "%.class", "%.pdf", "%.mkv", "%.mp4", "%.zip" },
			layout_config = {
				horizontal = {
					prompt_position = "top",
					preview_width = 0.55,
					results_width = 0.8,
				},
				vertical = {
					mirror = false,
				},
				width = 0.85,
				height = 0.92,
				preview_cutoff = 120,
			},
			file_previewer = require("telescope.previewers").vim_buffer_cat.new,
			grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
			qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
			file_sorter = require("telescope.sorters").get_fuzzy_file,
			generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
			buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
		},
		extensions = {
			aerial = {
				show_lines = false,
				show_nesting = {
					["_"] = false, -- This key will be the default
					lua = true, -- You can set the option for specific filetypes
				},
			},
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
			advanced_git_search = {
				-- Browse command to open commits in browser. Default fugitive GBrowse.
				browse_command = "GBrowse",
				-- fugitive or diffview
				diff_plugin = "diffview",
				-- customize git in previewer
				-- e.g. flags such as { "--no-pager" }, or { "-c", "delta.side-by-side=false" }
				git_flags = { "-c", "delta.side-by-side=true" },
				-- customize git diff in previewer
				-- e.g. flags such as { "--raw" }
				git_diff_flags = {},
				-- Show builtin git pickers when executing "show_custom_functions" or :AdvancedGitSearch
				show_builtin_git_pickers = false,
				entry_default_author_or_date = "author", -- one of "author" or "date"
				keymaps = {
					-- following keymaps can be overridden
					toggle_date_author = "<C-w>",
					open_commit_in_browser = "<C-o>",
					copy_commit_hash = "<C-y>",
					show_entire_commit = "<C-e>",
				},

				-- Telescope layout setup
				telescope_theme = {
					function_name_1 = {
						-- Theme options
					},
					function_name_2 = "dropdown",
					-- e.g. realistic example
					show_custom_functions = {
						layout_config = { width = 0.4, height = 0.4 },
					},
				},
			},
		},
	})

	require("telescope").load_extension("frecency")
	require("telescope").load_extension("fzf")
	require("telescope").load_extension("live_grep_args")
	require("telescope").load_extension("notify")
	require("telescope").load_extension("projects")
	require("telescope").load_extension("undo")
	require("telescope").load_extension("zoxide")
	require("telescope").load_extension("persisted")
	require("telescope").load_extension("aerial")
	require("telescope").load_extension("advanced_git_search")
end
