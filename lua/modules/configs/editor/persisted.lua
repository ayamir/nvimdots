return function()
	require("modules.utils").load_plugin("persisted", {
		save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
		autostart = true,
		-- Set `lazy = false` in `plugins/editor.lua` to enable this
		autoload = false,
		follow_cwd = true,
		use_git_branch = true,
		should_save = function()
			return vim.bo.filetype == "alpha" and false or true
		end,
	})
end
