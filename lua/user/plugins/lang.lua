local lang = {}

lang["lervag/vimtex"] = {
	lazy = false,
	config = require("configs.lang.vimtex"),
}

lang["MortenStabenau/matlab-vim"] = {
	lazy = true,
	ft = "matlab",
	config = require("configs.lang.matlab"),
}

lang["microsoft/python-type-stubs"] = {
	lazy = true,
}

lang["gentoo/gentoo-syntax"] = {
	lazy = true,
	ft = { "ebuild" },
}

return lang
