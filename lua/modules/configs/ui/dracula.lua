return function()
	require("modules.utils").load_plugin("dracula", {
		colors = {
			-- bg = "#282A36",
			-- fg = "#F8F8F2",
			selection = "#44475A",
			comment = "#9AA9D9",
			-- red = "#FF5555",
			-- orange = "#FFB86C",
			-- yellow = "#F1FA8C",
			-- green = "#50fa7b",
			-- purple = "#BD93F9",
			-- cyan = "#8BE9FD",
			-- pink = "#FF79C6",
			-- bright_red = "#FF6E6E",
			-- bright_green = "#69FF94",
			-- bright_yellow = "#FFFFA5",
			-- bright_blue = "#D6ACFF",
			-- bright_magenta = "#FF92DF",
			-- bright_cyan = "#A4FFFF",
			-- bright_white = "#FFFFFF",
			-- menu = "#21222C",
			-- visual = "#3E4452",
			-- gutter_fg = "#4B5263",
			-- nontext = "#3B4048",
			-- white = "#ABB2BF",
			-- black = "#191A21",
		},
		-- show the '~' characters after the end of buffers
		show_end_of_buffer = true, -- default false
		-- use transparent background
		transparent_bg = true, -- default false
		-- set custom lualine background color
		lualine_bg_color = "#44475a", -- default nil
		-- set italic comment
		italic_comment = true, -- default false
		-- overrides the default highlights with table see `:h synIDattr`
		overrides = {},
		-- You can use overrides as table like this
		-- overrides = {
		--   NonText = { fg = "white" }, -- set NonText fg to white
		--   NvimTreeIndentMarker = { link = "NonText" }, -- link to NonText highlight
		--   Nothing = {} -- clear highlight of Nothing
		-- },
		-- Or you can also use it like a function to get color from theme
		-- overrides = function (colors)
		--   return {
		--     NonText = { fg = colors.white }, -- set NonText fg to white of theme
		--   }
		-- end,
	})
end
