return function()
	require("modules.utils").load_plugin("grug-far", {
		windowCreationCommand = "bot split",
		disableBufferLineNumbers = false,
		icons = { enabled = true },
		engine = "ripgrep",
		engines = {
			ripgrep = {
				path = "rg",
				showReplaceDiff = true,
				placeholders = {
					enabled = true,
				},
			},
		},
		keymaps = {
			replace = { n = "R" },
			qflist = { n = "Q" },
			syncLocations = { n = "S" },
			syncLine = { n = "L" },
			close = { n = "C" },
			historyOpen = { n = "T" },
			historyAdd = { n = "A" },
			refresh = { n = "F" },
			openLocation = { n = "O" },
			openNextLocation = { n = "<Down>" },
			openPrevLocation = { n = "<Up>" },
			gotoLocation = { n = "<Enter>" },
			pickHistoryEntry = { n = "<Enter>" },
			abort = { n = "B" },
			help = { n = "g?" },
			toggleShowCommand = { n = "P" },
			swapEngine = { n = "E" },
			previewLocation = { n = "I" },
			swapReplacementInterpreter = { n = "X" },
			applyNext = { n = "J" },
			applyPrev = { n = "K" },
			nextInput = { n = "<Tab>" },
			prevInput = { n = "<S-Tab>" },
		},
	})
end
