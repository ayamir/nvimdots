return function()
	require("modules.utils").load_plugin("fcitx5", {
		msg = nil, -- string | nil: printed when startup is completed
		imname = { -- fcitx5.Imname | nil: imnames on each mode set as prior. See `:h map-table` for more in-depth information.
			norm = nil, -- string | nil: imname to set in normal mode. if nil, will restore the mode on exit.
			ins = nil,
			cmd = nil,
			vis = nil,
			sel = nil,
			opr = nil,
			term = nil,
			lang = nil,
		},
		remember_prior = true, -- boolean: if true, it remembers the mode on exit and restore it when entering the mode again.
		--                                 if false, uses what was set in config.
		define_autocmd = true, -- boolean: if true, defines autocmd at `ModeChanged` to switch fcitx5 mode.
		log = "warn", -- string: log level (default: warn)
	})
end
