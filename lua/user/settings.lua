-- Please check `lua/core/settings.lua` to view the full list of configurable settings
local settings = {}

-- Examples
settings["use_ssh"] = true

-- Disable the following two plugins
settings["disabled_plugins"] = {
	-- "rainbowhxch/accelerated-jk.nvim",
	--    "max397574/better-escape.nvim",
}

settings["colorscheme"] = "gruvbox"

settings["dashboard_image"] = {}
settings["dashboard_image"] = {
	[[                                                ]],
	[[                                          _.oo. ]],
	[[                  _.u[[/;:,.         .odMMMMMM' ]],
	[[               .o888UU[[[/;:-.  .o@P^    MMM^   ]],
	[[              oN88888UU[[[/;::-.        dP^     ]],
	[[             dNMMNN888UU[[[/;:--.   .o@P^       ]],
	[[            ,MMMMMMN888UU[[/;::-. o@^           ]],
	[[            NNMMMNN888UU[[[/~.o@P^              ]],
	[[            888888888UU[[[/o@^-..               ]],
	[[           oI8888UU[[[/o@P^:--..                ]],
	[[        .@^  YUU[[[/o@^;::---..                 ]],
	[[      oMP     ^/o@P^;:::---..                   ]],
	[[   .dMMM    .o@^ ^;::---...                     ]],
	[[  dMMMMMMM@^`       `^^^^                       ]],
	[[ YMMMUP^                                        ]],
	[[  ^^                                            ]],
	[[                                                ]],
}

return settings
