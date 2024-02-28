return function() -- This file MUST return a function accepting no parameter and has no return value
	require("nvim_comment").setup({
		hook = function()
			require("ts_context_commentstring.internal").update_commentstring()
		end,
	})
end
