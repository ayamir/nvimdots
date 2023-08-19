return function()
	require("modules.utils").gen_lspkind_hl()

	local icons = {
		cmp = require("modules.utils.icons").get("cmp", true),
		diagnostics = require("modules.utils.icons").get("diagnostics", true),
		kind = require("modules.utils.icons").get("kind", true),
		type = require("modules.utils.icons").get("type", true),
		ui = require("modules.utils.icons").get("ui", true),
	}

	local function set_sidebar_icons()
		-- Set icons for sidebar.
		local diagnostic_icons = {
			Error = icons.diagnostics.Error_alt,
			Warn = icons.diagnostics.Warning_alt,
			Info = icons.diagnostics.Information_alt,
			Hint = icons.diagnostics.Hint_alt,
		}
		for type, icon in pairs(diagnostic_icons) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl })
		end
	end

	set_sidebar_icons()

	require("lspsaga").setup({
		-- Breadcrumbs: https://dev.neovim.pro/lspsaga/breadcrumbs/
		symbol_in_winbar = {
			enable = true,
			separator = " " .. icons.ui.Separator,
			hide_keyword = false,
			show_file = false,
			folder_level = 1,
			color_mode = true,
			delay = 100,
		},
		-- https://dev.neovim.pro/lspsaga/callhierarchy/
		callhierarchy = {
			layout = "float",
			keys = {
				edit = "e",
				vsplit = "v",
				split = "s",
				tabe = "t",
				quit = "q",
				shuttle = "[]",
				toggle_or_req = "u",
				close = "<Esc>",
			},
		},
		-- https://dev.neovim.pro/lspsaga/codeaction/
		code_action = {
			num_shortcut = true,
			only_in_cursor = false,
			show_server_name = true,
			extend_gitsigns = false,
			keys = {
				quit = "q",
				exec = "<CR>",
			},
		},
		-- https://dev.neovim.pro/lspsaga/diagnostic/
		diagnostic = {
			show_code_action = true,
			jump_num_shortcut = true,
			max_width = 0.5,
			max_height = 0.6,
			text_hl_follow = true,
			border_follow = true,
			extend_relatedInformation = true,
			show_layout = "float",
			show_normal_height = 10,
			max_show_width = 0.9,
			max_show_height = 0.6,
			diagnostic_only_current = false,
			keys = {
				exec_action = "r",
				quit = "q",
				toggle_or_jump = "<CR>",
				quit_in_show = { "q", "<Esc>" },
			},
		},
		-- https://dev.neovim.pro/lspsaga/hover/
		hover = {
			max_width = 0.45,
			max_height = 0.7,
			open_link = "gl",
			open_cmd = "silent !" .. require("core.settings").external_browser,
		},
		-- https://dev.neovim.pro/lspsaga/implement/
		implement = {
			enable = true,
			sign = true,
			virtual_text = false,
			priority = 100,
		},
		-- https://dev.neovim.pro/lspsaga/lightbulb/
		lightbulb = {
			enable = false,
			sign = true,
			virtual_text = false,
			debounce = 10,
			sign_priority = 20,
		},
		-- https://dev.neovim.pro/lspsaga/rename/
		rename = {
			in_select = false,
			auto_save = false,
			project_max_width = 0.5,
			project_max_height = 0.5,
			keys = {
				quit = "<C-c>",
				exec = "<CR>",
				select = "x",
			},
		},
		-- https://dev.neovim.pro/lspsaga/misc/#beacon
		beacon = {
			enable = true,
			frequency = 12,
		},
		-- https://dev.neovim.pro/lspsaga/misc/#generic-ui-options
		ui = {
			border = "single", -- Can be single, double, rounded, solid, shadow.
			devicon = true,
			title = true,
			expand = icons.ui.ArrowClosed,
			collapse = icons.ui.ArrowOpen,
			code_action = icons.ui.CodeAction,
			actionfix = icons.ui.Spell,
			lines = { "┗", "┣", "┃", "━", "┏" },
			imp_sign = icons.kind.Implementation,
			kind = {
				-- Kind
				Class = { icons.kind.Class, "LspKindClass" },
				Constant = { icons.kind.Constant, "LspKindConstant" },
				Constructor = { icons.kind.Constructor, "LspKindConstructor" },
				Enum = { icons.kind.Enum, "LspKindEnum" },
				EnumMember = { icons.kind.EnumMember, "LspKindEnumMember" },
				Event = { icons.kind.Event, "LspKindEvent" },
				Field = { icons.kind.Field, "LspKindField" },
				File = { icons.kind.File, "LspKindFile" },
				Function = { icons.kind.Function, "LspKindFunction" },
				Interface = { icons.kind.Interface, "LspKindInterface" },
				Key = { icons.kind.Keyword, "LspKindKey" },
				Method = { icons.kind.Method, "LspKindMethod" },
				Module = { icons.kind.Module, "LspKindModule" },
				Namespace = { icons.kind.Namespace, "LspKindNamespace" },
				Number = { icons.kind.Number, "LspKindNumber" },
				Operator = { icons.kind.Operator, "LspKindOperator" },
				Package = { icons.kind.Package, "LspKindPackage" },
				Property = { icons.kind.Property, "LspKindProperty" },
				Struct = { icons.kind.Struct, "LspKindStruct" },
				TypeParameter = { icons.kind.TypeParameter, "LspKindTypeParameter" },
				Variable = { icons.kind.Variable, "LspKindVariable" },
				-- Type
				Array = { icons.type.Array, "LspKindArray" },
				Boolean = { icons.type.Boolean, "LspKindBoolean" },
				Null = { icons.type.Null, "LspKindNull" },
				Object = { icons.type.Object, "LspKindObject" },
				String = { icons.type.String, "LspKindString" },
				-- ccls-specific icons.
				TypeAlias = { icons.kind.TypeAlias, "LspKindTypeAlias" },
				Parameter = { icons.kind.Parameter, "LspKindParameter" },
				StaticMethod = { icons.kind.StaticMethod, "LspKindStaticMethod" },
				-- Microsoft-specific icons.
				Text = { icons.kind.Text, "LspKindText" },
				Snippet = { icons.kind.Snippet, "LspKindSnippet" },
				Folder = { icons.kind.Folder, "LspKindFolder" },
				Unit = { icons.kind.Unit, "LspKindUnit" },
				Value = { icons.kind.Value, "LspKindValue" },
			},
		},
		-- https://dev.neovim.pro/lspsaga/misc/#scrolling-keymaps
		scroll_preview = {
			scroll_down = "<C-d>",
			scroll_up = "<C-u>",
		},
		request_timeout = 3000,
	})
end
