return function()
	require("modules.utils").load_plugin("local-highlight", {
		hlgroup = "Search",
		cw_hlgroup = nil,
		-- Whether to display highlights in INSERT mode or not
		insert_mode = false,
		min_match_len = 1,
		max_match_len = math.huge,
	})
end
