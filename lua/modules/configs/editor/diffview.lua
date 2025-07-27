return function()
	require("modules.utils").load_plugin("diffview", {
		diff_binaries = false,
		enhanced_diff_hl = false,
		use_icons = true,
		show_help_hints = true,
		watch_index = true,
		git_cmd = { "git" },
		hg_cmd = { "hg" },
		view = {
			-- Config for changed files, and staged files in diff views.
			default = {
				layout = "diff2_horizontal",
				disable_diagnostics = true,
				winbar_info = false,
			},
			-- Config for conflicted files in diff views during a merge or rebase.
			merge_tool = {
				layout = "diff3_horizontal",
				disable_diagnostics = true,
				winbar_info = true,
			},
			-- Config for changed files in file history views.
			file_history = {
				layout = "diff2_horizontal",
				disable_diagnostics = true,
				winbar_info = false,
			},
		},
	})
end
