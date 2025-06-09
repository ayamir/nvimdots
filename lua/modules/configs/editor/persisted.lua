return function()
	vim.api.nvim_create_autocmd("User", {
		pattern = "PersistedLoadPost",
		desc = "Fix LSP/Highlighting on auto session restore",
		callback = function()
			local bufname = vim.api.nvim_buf_get_name(0)
			if bufname and bufname ~= "" then
				vim.defer_fn(function()
					vim.cmd("edit")
				end, 1)
			end
		end,
	})
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
