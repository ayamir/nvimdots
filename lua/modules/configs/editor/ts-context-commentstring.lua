return function()
	vim.g.skip_ts_context_commentstring_module = true
	require("modules.utils").load_plugin("ts_context_commentstring", {
		-- Whether to update the `commentstring` on the `CursorHold` autocmd
		enable_autocmd = false,
	})
end
