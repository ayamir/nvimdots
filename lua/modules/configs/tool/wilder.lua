return function()
	local wilder = require("wilder")
	local icons = { ui = require("modules.utils.icons").get("ui") }

	wilder.setup({ modes = { "/", "?" } })
	wilder.set_option("use_python_remote_plugin", 0)
	wilder.set_option("pipeline", {
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
	})

	local wildmenu_renderer = wilder.wildmenu_renderer({
		highlighter = wilder.lua_fzy_highlighter(),
		highlights = {
			accent = wilder.make_hl("WilderAccent", "Pmenu", { { a = 1 }, { a = 1 }, { foreground = "#f4468f" } }),
		},
		apply_incsearch_fix = true,
		separator = " | ",
		left = { " ", wilder.wildmenu_spinner(), " " },
		right = { " ", wilder.wildmenu_index() },
	})
	wilder.set_option(
		"renderer",
		wilder.renderer_mux({
			["/"] = wildmenu_renderer,
			substitute = wildmenu_renderer,
		})
	)
end
