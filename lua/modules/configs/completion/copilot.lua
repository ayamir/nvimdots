local M = {}

M["opts"] = function()
	return {
			cmp = {
				enabled = true,
				method = "getCompletionsCycling",
			},
			panel = {
				-- if true, it can interfere with completions in copilot-cmp
				enabled = false,
			},
			suggestion = {
				-- if true, it can interfere with completions in copilot-cmp
				enabled = false,
			},
			filetypes = {
				["dap-repl"] = false,
				["big_file_disabled_ft"] = false,
			},
		}
end

M["config"] = function(_, opts)
	vim.defer_fn(function()
		require("copilot").setup()
	end, 100)
end

return M