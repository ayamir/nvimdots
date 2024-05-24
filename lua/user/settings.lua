-- Please check `lua/core/settings.lua` to view the full list of configurable settings
local settings = {}

-- Examples
settings["use_ssh"] = false
settings["use_copilot"] = false
settings["colorscheme"] = "catppuccin-latte"
settings["background"] = "light"
settings["server_formatting_block_list"] = {
	lua_ls = true,
	tsserver = true,
	clangd = true,
	texlab = true,
	pyright = true,
}

settings["null_ls_deps"] = {
	"clang_format",
	"prettier",
	"shfmt",
	"stylua",
	"vint",
	"latexindent",
	"beautysh",
}

settings["lsp_deps"] = function(defaults)
	return {
		"bashls",
		"clangd",
		"html",
		"jsonls",
		"lua_ls",
		-- "pylsp",
	}
end

settings["disabled_plugins"] = {
	"nvim-tree/nvim-tree.lua",
	"akinsho/bufferline.nvim",
	"m4xshen/autoclose.nvim",
	-- "zbirenbaum/neodim",
}

settings["gui_config"] = {
	font_name = "Iosevka NFP",
	font_size = 11,
}

settings["treesitter_deps"] = {
	"bash",
	"c",
	"cpp",
	"css",
	"go",
	"gomod",
	"html",
	"javascript",
	"json",
	-- "latex",
	"lua",
	"make",
	"markdown",
	"markdown_inline",
	"python",
	"rust",
	"typescript",
	"vimdoc",
	"vue",
	"yaml",
	"ini",
}

return settings
