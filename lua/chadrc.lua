local icons = {
	documents = require("modules.utils.icons").get("documents", true),
	git = require("modules.utils.icons").get("git", true),
	ui = require("modules.utils.icons").get("ui", true),
	misc = require("modules.utils.icons").get("misc", true),
}
local header = require("core.settings").dashboard_image
local header_width = #header[1]
local newline = string.rep(" ", math.ceil(0.4 * header_width))
-- insert three blankline to the header
for _ = 1, 3 do
	table.insert(header, newline)
end

local options = {
	base46 = {
		theme = "catppuccin",
		hl_add = {},
		hl_override = {
			NvDashButtons = {
				italic = true,
			},
		},
		integrations = {
			"hop",
			"treesitter",
			"dap",
			"blankline",
			"edgy",
			"grug_far",
			"mason",
			"notify",
			"flash",
			"lspsaga",
			"whichkey",
			"trouble",
			"rainbowdelimiters",
			"git",
			"diffview",
			"devicons",
			"todo",
			"telescope",
		},
		changed_themes = {},
		transparency = false,
		theme_toggle = { "catppuccin", "catppuccin-latte" },
	},
	ui = {
		cmp = {
			icons_left = true, -- only for non-atom styles!
			style = "default", -- default/flat_light/flat_dark/atom/atom_colored
			abbr_maxwidth = 60,
			-- for tailwind, css lsp etc
			format_colors = { lsp = true, icon = "󱓻" },
		},

		telescope = { style = "borderless" }, -- borderless / bordered

		statusline = {
			enabled = true,
			theme = "default", -- default/vscode/vscode_colored/minimal
			-- default/round/block/arrow separators work only for default statusline theme
			-- round and block will work for minimal theme only
			separator_style = "default",
			order = nil,
			modules = nil,
		},

		-- lazyload it when there are 1+ buffers
		tabufline = {
			enabled = true,
			lazyload = true,
			order = { "treeOffset", "buffers", "tabs", "btns" },
			modules = nil,
			bufwidth = 21,
		},
	},

	nvdash = {
		load_on_startup = true,
		header = require("core.settings").dashboard_image,

		buttons = {
			{
				txt = icons.misc.Neovim .. "Telescope collections",
				keys = "space f c",
				cmd = "TelescopeCollections",
			},
			{
				txt = icons.documents.FileFind .. "Find files",
				keys = "space f f",
				cmd = "TelescopeFiles",
			},
			{
				txt = icons.ui.FolderWithHeart .. "Retrieve dossiers",
				keys = "space f d",
				cmd = "TelescopeDossier",
			},
			{
				txt = icons.documents.Word .. "Find patterns",
				keys = "space f p",
				cmd = "TelescopePatterns",
			},
			{
				txt = icons.git.Git .. "Locate Git objects",
				keys = "space f g",
				cmd = "TelescopeGit",
			},
			{
				txt = icons.misc.Ghost .. "Miscellaneous artifacts",
				keys = "space f m",
				cmd = "TelescopeMisc",
			},
			{ txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
			{
				txt = function()
					local stats = require("lazy").stats()
					local ms = math.floor(stats.startuptime) .. " ms"
					return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
				end,
				hl = "NvDashFooter",
				no_gap = true,
			},
			{ txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
		},
	},

	term = {
		base46_colors = true,
		winopts = { number = false, relativenumber = false },
		sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
		float = {
			relative = "editor",
			row = 0.1,
			col = 0.1,
			width = 0.8,
			height = 0.8,
			border = "single",
		},
	},

	lsp = { signature = true },

	cheatsheet = {
		theme = "grid", -- simple/grid
		excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" }, -- can add group name or with mode
	},

	mason = { pkgs = {}, skip = {} },

	colorify = {
		enabled = true,
		mode = "virtual", -- fg, bg, virtual
		virt_text = "󱓻 ",
		highlight = { hex = true, lspvars = true },
	},
}

local status, chadrc = pcall(require, "chadrc")
return vim.tbl_deep_extend("force", options, status and chadrc or {})
