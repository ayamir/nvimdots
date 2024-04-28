return {
	keys = {
		["$"] = { escape = true, close = true, pair = "$$", disabled_filetypes = {} },
	},
	options = {
		disabled_filetypes = { "big_file_disabled_ft" },
		disable_when_touch = true,
		touch_regex = "[%w(%[{]",
	},
}
