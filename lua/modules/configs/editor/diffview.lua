return function()
	local actions = require("diffview.actions")

	require("modules.utils").load_plugin("diffview", {
		diff_binaries = false, -- Show diffs for binaries
		enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
		git_cmd = { "git" }, -- The git executable followed by default args.
		hg_cmd = { "hg" }, -- The hg executable followed by default args.
		use_icons = true, -- Requires nvim-web-devicons
		show_help_hints = true, -- Show hints for how to open the help panel
		watch_index = true, -- Update views and index buffers when the git index changes.
		icons = { -- Only applies when use_icons is true.
			folder_closed = "",
			folder_open = "",
		},
		signs = {
			fold_closed = "",
			fold_open = "",
			done = "✓",
		},
		view = {
			-- Configure the layout and behavior of different types of views.
			-- Available layouts:
			--  'diff1_plain'
			--    |'diff2_horizontal'
			--    |'diff2_vertical'
			--    |'diff3_horizontal'
			--    |'diff3_vertical'
			--    |'diff3_mixed'
			--    |'diff4_mixed'
			-- For more info, see ':h diffview-config-view.x.layout'.
			default = {
				-- Config for changed files, and staged files in diff views.
				layout = "diff2_horizontal",
				winbar_info = false, -- See ':h diffview-config-view.x.winbar_info'
			},
			merge_tool = {
				-- Config for conflicted files in diff views during a merge or rebase.
				layout = "diff3_horizontal",
				disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
				winbar_info = true, -- See ':h diffview-config-view.x.winbar_info'
			},
			file_history = {
				-- Config for changed files in file history views.
				layout = "diff2_horizontal",
				winbar_info = false, -- See ':h diffview-config-view.x.winbar_info'
			},
		},
		file_panel = {
			listing_style = "tree", -- One of 'list' or 'tree'
			tree_options = { -- Only applies when listing_style is 'tree'
				flatten_dirs = true, -- Flatten dirs that only contain one single dir
				folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
			},
			win_config = { -- See ':h diffview-config-win_config'
				position = "left",
				width = 35,
				win_opts = {},
			},
		},
		file_history_panel = {
			log_options = { -- See ':h diffview-config-log_options'
				git = {
					single_file = {
						diff_merges = "combined",
					},
					multi_file = {
						diff_merges = "first-parent",
					},
				},
				hg = {
					single_file = {},
					multi_file = {},
				},
			},
			win_config = { -- See ':h diffview-config-win_config'
				position = "bottom",
				height = 16,
				win_opts = {},
			},
		},
		commit_log_panel = {
			win_config = { -- See ':h diffview-config-win_config'
				win_opts = {},
			},
		},
		default_args = { -- Default args prepended to the arg-list for the listed commands
			DiffviewOpen = {},
			DiffviewFileHistory = {},
		},
		hooks = {}, -- See ':h diffview-config-hooks'
		keymaps = {
			disable_defaults = false, -- Disable the default keymaps
			view = {
				-- The `view` bindings are active in the diff buffers, only when the current
				-- tabpage is a Diffview.
				{
					"n",
					"<tab>",
					actions.select_next_entry,
					{ desc = "diffview: Open the diff for the next file" },
				},
				{
					"n",
					"<s-tab>",
					actions.select_prev_entry,
					{ desc = "diffview: Open the diff for the previous file" },
				},
				{
					"n",
					"gf",
					actions.goto_file_edit,
					{ desc = "diffview: Open the file in the previous tabpage" },
				},
				{
					"n",
					"<C-w><C-f>",
					actions.goto_file_split,
					{ desc = "diffview: Open the file in a new split" },
				},
				{
					"n",
					"<C-w>gf",
					actions.goto_file_tab,
					{ desc = "diffview: Open the file in a new tabpage" },
				},
				{
					"n",
					"<leader>e",
					actions.focus_files,
					{ desc = "diffview: Bring focus to the file panel" },
				},
				{
					"n",
					"<leader>b",
					actions.toggle_files,
					{ desc = "diffview: Toggle the file panel." },
				},
				{
					"n",
					"g<C-x>",
					actions.cycle_layout,
					{ desc = "diffview: Cycle through available layouts." },
				},
				{
					"n",
					"[x",
					actions.prev_conflict,
					{ desc = "diffview: In the merge-tool: jump to the previous conflict" },
				},
				{
					"n",
					"]x",
					actions.next_conflict,
					{ desc = "diffview: In the merge-tool: jump to the next conflict" },
				},
				{
					"n",
					"<leader>co",
					actions.conflict_choose("ours"),
					{ desc = "diffview: Choose the OURS version of a conflict" },
				},
				{
					"n",
					"<leader>ct",
					actions.conflict_choose("theirs"),
					{ desc = "diffview: Choose the THEIRS version of a conflict" },
				},
				{
					"n",
					"<leader>cb",
					actions.conflict_choose("base"),
					{ desc = "diffview: Choose the BASE version of a conflict" },
				},
				{
					"n",
					"<leader>ca",
					actions.conflict_choose("all"),
					{ desc = "diffview: Choose all the versions of a conflict" },
				},
				{
					"n",
					"dx",
					actions.conflict_choose("none"),
					{ desc = "diffview: Delete the conflict region" },
				},
				{
					"n",
					"<leader>cO",
					actions.conflict_choose_all("ours"),
					{ desc = "diffview: Choose the OURS version of a conflict for the whole file" },
				},
				{
					"n",
					"<leader>cT",
					actions.conflict_choose_all("theirs"),
					{ desc = "diffview: Choose the THEIRS version of a conflict for the whole file" },
				},
				{
					"n",
					"<leader>cB",
					actions.conflict_choose_all("base"),
					{ desc = "diffview: Choose the BASE version of a conflict for the whole file" },
				},
				{
					"n",
					"<leader>cA",
					actions.conflict_choose_all("all"),
					{ desc = "diffview: Choose all the versions of a conflict for the whole file" },
				},
				{
					"n",
					"dX",
					actions.conflict_choose_all("none"),
					{ desc = "diffview: Delete the conflict region for the whole file" },
				},
			},
			diff1 = {
				-- Mappings in single window diff layouts
				{
					"n",
					"g?",
					actions.help({ "view", "diff1" }),
					{ desc = "diffview: Open the help panel" },
				},
			},
			diff2 = {
				-- Mappings in 2-way diff layouts
				{
					"n",
					"g?",
					actions.help({ "view", "diff2" }),
					{ desc = "diffview: Open the help panel" },
				},
			},
			diff3 = {
				-- Mappings in 3-way diff layouts
				{
					{ "n", "x" },
					"2do",
					actions.diffget("ours"),
					{ desc = "diffview: Obtain the diff hunk from the OURS version of the file" },
				},
				{
					{ "n", "x" },
					"3do",
					actions.diffget("theirs"),
					{ desc = "diffview: Obtain the diff hunk from the THEIRS version of the file" },
				},
				{
					"n",
					"g?",
					actions.help({ "view", "diff3" }),
					{ desc = "diffview: Open the help panel" },
				},
			},
			diff4 = {
				-- Mappings in 4-way diff layouts
				{
					{ "n", "x" },
					"1do",
					actions.diffget("base"),
					{ desc = "diffview: Obtain the diff hunk from the BASE version of the file" },
				},
				{
					{ "n", "x" },
					"2do",
					actions.diffget("ours"),
					{ desc = "diffview: Obtain the diff hunk from the OURS version of the file" },
				},
				{
					{ "n", "x" },
					"3do",
					actions.diffget("theirs"),
					{ desc = "diffview: Obtain the diff hunk from the THEIRS version of the file" },
				},
				{
					"n",
					"g?",
					actions.help({ "view", "diff4" }),
					{ desc = "diffview: Open the help panel" },
				},
			},
			file_panel = {
				{
					"n",
					"j",
					actions.next_entry,
					{ desc = "diffview: Bring the cursor to the next file entry" },
				},
				{
					"n",
					"<down>",
					actions.next_entry,
					{ desc = "diffview: Bring the cursor to the next file entry" },
				},
				{
					"n",
					"k",
					actions.prev_entry,
					{ desc = "diffview: Bring the cursor to the previous file entry" },
				},
				{
					"n",
					"<up>",
					actions.prev_entry,
					{ desc = "diffview: Bring the cursor to the previous file entry" },
				},
				{
					"n",
					"<cr>",
					actions.select_entry,
					{ desc = "diffview: Open the diff for the selected entry" },
				},
				{
					"n",
					"o",
					actions.select_entry,
					{ desc = "diffview: Open the diff for the selected entry" },
				},
				{
					"n",
					"l",
					actions.select_entry,
					{ desc = "diffview: Open the diff for the selected entry" },
				},
				{
					"n",
					"<2-LeftMouse>",
					actions.select_entry,
					{ desc = "diffview: Open the diff for the selected entry" },
				},
				{
					"n",
					"-",
					actions.toggle_stage_entry,
					{ desc = "diffview: Stage / unstage the selected entry" },
				},
				{
					"n",
					"s",
					actions.toggle_stage_entry,
					{ desc = "diffview: Stage / unstage the selected entry" },
				},
				{ "n", "S", actions.stage_all, { desc = "diffview: Stage all entries" } },
				{ "n", "U", actions.unstage_all, { desc = "diffview: Unstage all entries" } },
				{
					"n",
					"X",
					actions.restore_entry,
					{ desc = "diffview: Restore entry to the state on the left side" },
				},
				{
					"n",
					"L",
					actions.open_commit_log,
					{ desc = "diffview: Open the commit log panel" },
				},
				{ "n", "zo", actions.open_fold, { desc = "diffview: Expand fold" } },
				{ "n", "h", actions.close_fold, { desc = "diffview: Collapse fold" } },
				{ "n", "zc", actions.close_fold, { desc = "diffview: Collapse fold" } },
				{ "n", "za", actions.toggle_fold, { desc = "diffview: Toggle fold" } },
				{ "n", "zR", actions.open_all_folds, { desc = "diffview: Expand all folds" } },
				{ "n", "zM", actions.close_all_folds, { desc = "diffview: Collapse all folds" } },
				{ "n", "<c-b>", actions.scroll_view(-0.25), { desc = "diffview: Scroll the view up" } },
				{ "n", "<c-f>", actions.scroll_view(0.25), { desc = "diffview: Scroll the view down" } },
				{
					"n",
					"<tab>",
					actions.select_next_entry,
					{ desc = "diffview: Open the diff for the next file" },
				},
				{
					"n",
					"<s-tab>",
					actions.select_prev_entry,
					{ desc = "diffview: Open the diff for the previous file" },
				},
				{
					"n",
					"gf",
					actions.goto_file_edit,
					{ desc = "diffview: Open the file in the previous tabpage" },
				},
				{
					"n",
					"<C-w><C-f>",
					actions.goto_file_split,
					{ desc = "diffview: Open the file in a new split" },
				},
				{
					"n",
					"<C-w>gf",
					actions.goto_file_tab,
					{ desc = "diffview: Open the file in a new tabpage" },
				},
				{
					"n",
					"i",
					actions.listing_style,
					{ desc = "diffview: Toggle between 'list' and 'tree' views" },
				},
				{
					"n",
					"f",
					actions.toggle_flatten_dirs,
					{ desc = "diffview: Flatten empty subdirectories in tree listing style" },
				},
				{
					"n",
					"R",
					actions.refresh_files,
					{ desc = "diffview: Update stats and entries in the file list" },
				},
				{
					"n",
					"<leader>e",
					actions.focus_files,
					{ desc = "diffview: Bring focus to the file panel" },
				},
				{ "n", "<leader>b", actions.toggle_files, { desc = "diffview: Toggle the file panel" } },
				{ "n", "g<C-x>", actions.cycle_layout, { desc = "diffview: Cycle available layouts" } },
				{
					"n",
					"[x",
					actions.prev_conflict,
					{ desc = "diffview: Go to the previous conflict" },
				},
				{ "n", "]x", actions.next_conflict, { desc = "diffview: Go to the next conflict" } },
				{ "n", "g?", actions.help("file_panel"), { desc = "diffview: Open the help panel" } },
				{
					"n",
					"<leader>cO",
					actions.conflict_choose_all("ours"),
					{ desc = "diffview: Choose the OURS version of a conflict for the whole file" },
				},
				{
					"n",
					"<leader>cT",
					actions.conflict_choose_all("theirs"),
					{ desc = "diffview: Choose the THEIRS version of a conflict for the whole file" },
				},
				{
					"n",
					"<leader>cB",
					actions.conflict_choose_all("base"),
					{ desc = "diffview: Choose the BASE version of a conflict for the whole file" },
				},
				{
					"n",
					"<leader>cA",
					actions.conflict_choose_all("all"),
					{ desc = "diffview: Choose all the versions of a conflict for the whole file" },
				},
				{
					"n",
					"dX",
					actions.conflict_choose_all("none"),
					{ desc = "diffview: Delete the conflict region for the whole file" },
				},
			},
			file_history_panel = {
				{ "n", "g!", actions.options, { desc = "diffview: Open the option panel" } },
				{
					"n",
					"<C-A-d>",
					actions.open_in_diffview,
					{ desc = "diffview: Open the entry under the cursor in a diffview" },
				},
				{
					"n",
					"y",
					actions.copy_hash,
					{ desc = "diffview: Copy the commit hash of the entry under the cursor" },
				},
				{ "n", "L", actions.open_commit_log, { desc = "diffview: Show commit details" } },
				{ "n", "zR", actions.open_all_folds, { desc = "diffview: Expand all folds" } },
				{ "n", "zM", actions.close_all_folds, { desc = "diffview: Collapse all folds" } },
				{
					"n",
					"j",
					actions.next_entry,
					{ desc = "diffview: Bring the cursor to the next file entry" },
				},
				{
					"n",
					"<down>",
					actions.next_entry,
					{ desc = "diffview: Bring the cursor to the next file entry" },
				},
				{
					"n",
					"k",
					actions.prev_entry,
					{ desc = "diffview: Bring the cursor to the previous file entry." },
				},
				{
					"n",
					"<up>",
					actions.prev_entry,
					{ desc = "diffview: Bring the cursor to the previous file entry." },
				},
				{
					"n",
					"<cr>",
					actions.select_entry,
					{ desc = "diffview: Open the diff for the selected entry." },
				},
				{
					"n",
					"o",
					actions.select_entry,
					{ desc = "diffview: Open the diff for the selected entry." },
				},
				{
					"n",
					"<2-LeftMouse>",
					actions.select_entry,
					{ desc = "diffview: Open the diff for the selected entry." },
				},
				{ "n", "<c-b>", actions.scroll_view(-0.25), { desc = "diffview: Scroll the view up" } },
				{ "n", "<c-f>", actions.scroll_view(0.25), { desc = "diffview: Scroll the view down" } },
				{
					"n",
					"<tab>",
					actions.select_next_entry,
					{ desc = "diffview: Open the diff for the next file" },
				},
				{
					"n",
					"<s-tab>",
					actions.select_prev_entry,
					{ desc = "diffview: Open the diff for the previous file" },
				},
				{
					"n",
					"gf",
					actions.goto_file_edit,
					{ desc = "diffview: Open the file in the previous tabpage" },
				},
				{
					"n",
					"<C-w><C-f>",
					actions.goto_file_split,
					{ desc = "diffview: Open the file in a new split" },
				},
				{
					"n",
					"<C-w>gf",
					actions.goto_file_tab,
					{ desc = "diffview: Open the file in a new tabpage" },
				},
				{
					"n",
					"<leader>e",
					actions.focus_files,
					{ desc = "diffview: Bring focus to the file panel" },
				},
				{ "n", "<leader>b", actions.toggle_files, { desc = "diffview: Toggle the file panel" } },
				{ "n", "g<C-x>", actions.cycle_layout, { desc = "diffview: Cycle available layouts" } },
				{ "n", "g?", actions.help("file_history_panel"), { desc = "diffview: Open the help panel" } },
			},
			option_panel = {
				{ "n", "<tab>", actions.select_entry, { desc = "diffview: Change the current option" } },
				{ "n", "q", actions.close, { desc = "diffview: Close the panel" } },
				{ "n", "g?", actions.help("option_panel"), { desc = "diffview: Open the help panel" } },
			},
			help_panel = {
				{ "n", "q", actions.close, { desc = "diffview: Close help menu" } },
				{ "n", "<esc>", actions.close, { desc = "diffview: Close help menu" } },
			},
		},
	})
end
