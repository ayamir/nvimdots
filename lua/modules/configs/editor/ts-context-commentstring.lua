return function()
	vim.g.skip_ts_context_commentstring_module = true
	require("ts_context_commentstring").setup({
		-- Whether to update the `commentstring` on the `CursorHold` autocmd
		enable_autocmd = false,
	})
end
