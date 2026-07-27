local settings = require("core.settings")
local nvchad = settings.nvchad or {}
local icons = require("modules.utils.icons")

local nvdash_buttons = {
	{
		txt = icons.get("misc", true).Neovim .. "Search collections",
		keys = "<leader>fc",
		display_keys = "space f c",
		cmd = "lua require('keymap.helpers').search_collections()",
	},
	{
		txt = icons.get("documents", true).FileFind .. "Find files",
		keys = "<leader>ff",
		display_keys = "space f f",
		cmd = "lua require('search').open({ collection = 'file' })",
	},
	{
		txt = icons.get("ui", true).FolderWithHeart .. "Retrieve dossiers",
		keys = "<leader>fd",
		display_keys = "space f d",
		cmd = "lua require('search').open({ collection = 'dossier' })",
	},
	{
		txt = icons.get("documents", true).Word .. "Find patterns",
		keys = "<leader>fp",
		display_keys = "space f p",
		cmd = "lua require('search').open({ collection = 'pattern' })",
	},
	{
		txt = icons.get("git", true).Git .. "Locate Git objects",
		keys = "<leader>fg",
		display_keys = "space f g",
		cmd = "lua require('search').open({ collection = 'git' })",
	},
	{
		txt = icons.get("misc", true).Ghost .. "Miscellaneous artifacts",
		keys = "<leader>fm",
		display_keys = "space f m",
		cmd = "lua require('search').open({ collection = 'misc' })",
	},
}

local function nvdash_button_config()
	local buttons = {}
	for _, button in ipairs(nvdash_buttons) do
		local item = vim.deepcopy(button, true)
		item.keys = item.display_keys
		item.display_keys = nil
		table.insert(buttons, item)
	end

	table.insert(buttons, { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true })
	table.insert(buttons, {
		txt = function()
			local stats = require("lazy").stats()
			local ms = math.floor(stats.startuptime) .. " ms"
			return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
		end,
		hl = "NvDashFooter",
		no_gap = true,
		content = "fit",
	})
	table.insert(buttons, { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true })

	return buttons
end

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("NvimdotsNvDashKeymaps", { clear = true }),
	pattern = "nvdash",
	callback = function(event)
		for _, button in ipairs(nvdash_buttons) do
			vim.keymap.set("n", button.keys, "<cmd>" .. button.cmd .. "<cr>", {
				buffer = event.buf,
				nowait = true,
				silent = true,
			})
		end
	end,
})

local function nvim_tree_offset()
	if vim.bo.filetype == "NvimTree" then
		return ""
	end

	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if
			vim.api.nvim_win_get_config(win).relative == ""
			and vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "NvimTree"
		then
			local width = vim.api.nvim_win_get_width(win)
			return "%#NvimTreeNormal#" .. string.rep(" ", width) .. "%#NvimTreeWinSeparator#│"
		end
	end

	return ""
end

local options = {
	base46 = {
		theme = "onedark",
		hl_add = {},
		hl_override = {},
		integrations = {},
		changed_themes = {},
		transparency = false,
		theme_toggle = { "onedark", "one_light" },
	},

	ui = {
		cmp = {
			icons_left = false,
			style = "default",
			abbr_maxwidth = 60,
			format_colors = { lsp = true, icon = "󱓻" },
		},
		telescope = { style = "borderless" },
		statusline = {
			enabled = true,
			theme = "default",
			separator_style = "default",
			order = nil,
			modules = nil,
		},
		tabufline = {
			enabled = true,
			lazyload = true,
			treeOffsetFt = "NvimTree",
			order = { "treeOffset", "buffers", "tabs", "btns" },
			modules = nil,
			bufwidth = 21,
		},
	},

	nvdash = {
		load_on_startup = false,
		header = settings.dashboard_image,
		buttons = nvdash_button_config,
	},
	term = {
		startinsert = true,
		base46_colors = true,
		winopts = { number = false, relativenumber = false },
		sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
		float = {
			relative = "editor",
			row = 0.3,
			col = 0.25,
			width = 0.5,
			height = 0.4,
			border = "single",
		},
	},
	lsp = { signature = true },
	cheatsheet = {
		theme = "grid",
		excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" },
	},
	mason = { pkgs = {}, skip = {} },
	colorify = {
		enabled = true,
		mode = "virtual",
		virt_text = "󱓻 ",
		highlight = { hex = true, lspvars = true },
	},
}

local overrides = {
	base46 = {
		theme = nvchad.theme,
		theme_toggle = nvchad.theme_toggle,
		transparency = settings.transparent_background,
		hl_override = {
			["@comment"] = { italic = true },
			["@keyword"] = { italic = true, bold = true },
			NvDashButtons = { italic = true },
			Function = { bold = true },
			Keyword = { italic = true },
			Operator = { bold = true },
			Conditional = { bold = true },
			Loop = { bold = true },
			Boolean = { italic = true, bold = true },
			Comment = { italic = true },
		},
		hl_add = vim.tbl_deep_extend("force", {
			SnacksPickerListCursorLine = { bg = "pmenu_bg", fg = "black" },
		}, nvchad.hl_add or {}),
		integrations = nvchad.integrations,
	},
	nvdash = vim.tbl_deep_extend("force", {
		load_on_startup = false,
	}, nvchad.nvdash or {}),
	ui = {
		statusline = vim.tbl_deep_extend("force", {
			order = {
				"treeOffset",
				"mode",
				"file",
				"git",
				"%=",
				"lsp_msg",
				"%=",
				"diagnostics",
				"lsp",
				"cwd",
				"cursor",
			},
			modules = {
				treeOffset = nvim_tree_offset,
			},
		}, (nvchad.ui and nvchad.ui.statusline) or {}),
		tabufline = vim.tbl_deep_extend("force", {
			modules = {
				btns = function()
					return require("modules.utils.nvchad_theme").tabufline_btns()
				end,
				treeOffset = nvim_tree_offset,
			},
		}, (nvchad.ui and nvchad.ui.tabufline) or {}),
	},
	term = vim.tbl_deep_extend("force", {}, options.term, nvchad.term or {}),
}

return vim.tbl_deep_extend("force", options, overrides)
