return function()
	require("modules.utils").load_plugin("smartyank", {
		-- disabled here since highlight on yank is already enabled
		highlight = { enabled = false },
		clipboard = { enabled = true },
		tmux = {
			enabled = true,
			-- remove `-w` to disable copy to host client's clipboard
			cmd = { "tmux", "set-buffer", "-w" },
		},
		osc52 = {
			enabled = true,
			ssh_only = true,
			silent = true,
			-- use tmux escape sequence, only enable if you're using tmux and have issues
			-- escseq = "tmux",
		},
		-- copy indiscriminately
		validate_yank = false,
	})
end
