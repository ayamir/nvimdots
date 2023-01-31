local sessions_dir = vim.fn.stdpath("data") .. "/sessions/"

local opts = {
	log_level = "info",
	auto_session_enable_last_session = true,
	auto_session_root_dir = sessions_dir,
	auto_session_enabled = true,
	auto_save_enabled = true,
	auto_restore_enabled = true,
	auto_session_suppress_dirs = nil,
}

require("auto-session").setup(opts)
