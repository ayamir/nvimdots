return function()
	local vim_path = require("core.global").vim_path
	local snippet_path = vim_path .. "/snips/"
	local user_snippet_path = vim_path .. "/lua/user/snips/"

	require("modules.utils").load_plugin("luasnip", {
		history = true,
		update_events = "TextChanged,TextChangedI",
		delete_check_events = "TextChanged,InsertLeave",
	}, false, require("luasnip").config.set_config)

	require("luasnip.loaders.from_vscode").lazy_load({
		paths = {
			snippet_path,
			user_snippet_path,
		},
	})
	require("luasnip.loaders.from_lua").lazy_load()
	require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip.loaders.from_snipmate").lazy_load()
end
