return function()
	require("im_select").setup({
		default_im_select = "keyboard-us",

		-- Can be binary's name or binary's full path,
		-- e.g. 'im-select' or '/usr/local/bin/im-select'
		-- For Windows/WSL, default: "im-select.exe"
		-- For macOS, default: "im-select"
		-- For Linux, default: "fcitx5-remote" or "fcitx-remote" or "ibus"
		default_command = "fcitx5-remote",

		-- Restore the default input method state when the following events are triggered
		set_default_events = { "VimEnter", "InsertLeave" },

		-- Restore the previous used input method state when the following events
		-- are triggered, if you don't want to restore previous used im in Insert mode,
		-- e.g. deprecated `disable_auto_restore = 1`, just let it empty
		-- as `set_previous_events = {}`
		set_previous_events = { "InsertEnter" },

		-- Show notification about how to install executable binary when binary missed
		keep_quiet_on_no_binary = false,

		-- Async run `default_command` to switch IM or not
		async_switch_im = false,
	})
end
