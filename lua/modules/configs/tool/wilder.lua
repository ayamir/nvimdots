local M = {}

M["opts"] = function()
	local wilder = require("wilder")
	local icons = { ui = require("modules.utils.icons").get("ui") }
	local popupmenu_renderer = wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
		border = "rounded",
		highlights = {
			default = "Pmenu",
			border = "PmenuBorder", -- highlight to use for the border
			accent = wilder.make_hl("WilderAccent", "CmpItemAbbr", "CmpItemAbbrMatch"),
		},
		empty_message = wilder.popupmenu_empty_message_with_spinner(),
		highlighter = wilder.lua_fzy_highlighter(),
		left = {
			" ",
			wilder.popupmenu_devicons(),
			wilder.popupmenu_buffer_flags({
				flags = " a + ",
				icons = { ["+"] = icons.ui.Pencil, a = icons.ui.Indicator, h = icons.ui.File },
			}),
		},
		right = {
			" ",
			wilder.popupmenu_scrollbar(),
		},
	}))
	local wildmenu_renderer = wilder.wildmenu_renderer({
		highlighter = wilder.lua_fzy_highlighter(),
		apply_incsearch_fix = true,
		separator = " | ",
		left = { " ", wilder.wildmenu_spinner(), " " },
		right = { " ", wilder.wildmenu_index() },
	})

	return {
		setup = { modes = { ":", "/", "?" } },
		set_option = {
			use_python_remove_plugin = 0,
			pipeline = {
				wilder.branch(
					wilder.cmdline_pipeline({ use_python = 0, fuzzy = 1, fuzzy_filter = wilder.lua_fzy_filter() }),
					wilder.vim_search_pipeline(),
					{
						wilder.check(function(_, x)
							return x == ""
						end),
						wilder.history(),
						wilder.result({
							draw = {
								function(_, x)
									return icons.ui.Calendar .. " " .. x
								end,
							},
						}),
					}
				),
			},
			render = wilder.renderer_mux({
				[":"] = popupmenu_renderer,
				["/"] = wildmenu_renderer,
				substitute = wildmenu_renderer,
			})
		}
	}
end

M["config"] = function(_, opts)
	local wilder = require("wilder")

	wilder.setup(opts["setup"])
	wilder.setup(opts["set_option"])
end

return M