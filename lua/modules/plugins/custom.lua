local custom = {}

custom["RRethy/nvim-base16"] = {
	lazy = false,
	event = "BufRead",
	-- config = require("custom.configname"), -- Require that config
}

custom["liuchengxu/vista.vim"] = {
	lazy = true,
    cmd = "Vista",
	-- config = require("custom.vista"), -- Require that config
}

return custom
