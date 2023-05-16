return function()
	require("auto-session").setup({
		log_level = "info",
		auto_session_enable_last_session = true,
		auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
		auto_session_enabled = true,
		auto_save_enabled = true,
		auto_restore_enabled = true,
		auto_session_suppress_dirs = nil,
		session_lens = {
			-- If `load_on_setup` is set to false, please use `SessionLensToggle` to manually load this add-on.
			load_on_setup = false,
			theme_conf = { border = true },
			previewer = false,
		},
	})

	vim.api.nvim_create_user_command("SessionLensToggle", function()
		if not package.loaded["auto-session.session-lens"] then
			require("auto-session").setup_session_lens()
		end
		require("auto-session.session-lens").search_session()
	end, { nargs = 0 })
end
