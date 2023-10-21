return function()
	local snippet_path = vim.fn.stdpath("config") .. "/snips/"
	if not vim.tbl_contains(vim.opt.rtp:get(), snippet_path) then
		vim.opt.rtp:append(snippet_path)
	end

	require("modules.utils").load_plugin("luasnip", {
		history = true,
		update_events = "TextChanged,TextChangedI",
		delete_check_events = "TextChanged,InsertLeave",
	}, false, require("luasnip").config.set_config)
	require("luasnip.loaders.from_lua").lazy_load()
	require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip.loaders.from_snipmate").lazy_load()
end
