return function()
	require("modules.utils").load_plugin("diffview", {
		diff_binaries = false, -- Show diffs for binaries
		enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
		git_cmd = { "git" }, -- The git executable followed by default args.
		hg_cmd = { "hg" }, -- The hg executable followed by default args.
		use_icons = true, -- Requires nvim-web-devicons
		show_help_hints = true, -- Show hints for how to open the help panel
		watch_index = true, -- Update views and index buffers when the git index changes.
	})
end
