return function()
	vim.defer_fn(function()
		require("modules.utils").load_plugin("copilot", {
			panel = {
				-- if true, it can interfere with completions in blink-copilot
				enabled = false,
			},
			suggestion = {
				-- if true, it can interfere with completions in blink-copilot
				enabled = false,
			},
			filetypes = {
				["dap-repl"] = false,
				["fugitive"] = false,
				["fugitiveblame"] = false,
				["git"] = false,
				["gitcommit"] = false,
				["log"] = false,
				["toggleterm"] = false,
			},
		})
	end, 100)
end
