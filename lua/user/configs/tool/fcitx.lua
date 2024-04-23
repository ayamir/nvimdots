return function()
	require("fcitx")({
		enable = {
			normal = true,
			insert = true,
			cmdline = true,
			cmdtext = true,
			terminal = true,
			select = true,
		},
		guess_initial_status = {
			normal = {},
			insert = { "select", "cmdtext" },
			cmdline = { "normal" },
			cmdtext = { "cmdline", "insert" },
			terminal = { "cmdline", "normal" },
			select = { "insert", "cmdtext" },
		},
		threshold = 30,
		log = false,
	})
end
