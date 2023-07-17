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
		scroll_preview = {
			scroll_down = "<C-j>",
			scroll_up = "<C-k>",
		},
		request_timeout = 3000,
		finder = {
			silent = true,
			default = "def+ref+imp",
			layout = "float",
			filter = {},
			keys = {
				shuttle = "[]",
				toggle_or_open = "<CR>",
				jump_to = "e",
				vsplit = "v",
				split = "s",
				tabe = "t",
				tabnew = "n",
				quit = "q",
				close = "<Esc>",
			},
		},
		definition = {
			keys = {
				edit = "<C-c>o",
				vsplit = "<C-c>v",
				split = "<C-c>s",
				tabe = "<C-c>t",
				close = "<C-c>q",
				quit = "q",
			},
		},
		code_action = {
			num_shortcut = true,
			show_server_name = true,
			extend_gitsigns = false,
			keys = {
				quit = "q",
				exec = "<CR>",
			},
		},
		lightbulb = {
			enable = false,
			sign = true,
			sign_priority = 20,
			virtual_text = false,
		},
		diagnostic = {
			max_width = 0.5,
			max_height = 0.6,
			text_hl_follow = true,
			show_code_action = true,
			border_follow = true,
			diagnostic_only_current = false,
			extend_relatedInformation = false,
			jump_num_shortcut = true,
			show_layout = "float",
			keys = {
				exec_action = "r",
				quit = "q",
				toggle_or_jump = "<CR>",
				quit_in_show = { "q", "<Esc>" },
			},
		},
		rename = {
			in_select = false,
			auto_save = false,
			keys = {
				quit = "<C-c>",
				select = "x",
				exec = "<CR>",
			},
		},
		hover = {
			max_width = 0.3,
			max_height = 0.7,
			open_link = "gl",
			open_browser = "silent !" .. require("core.settings").external_browser,
		},
		outline = {
			win_position = "right",
			win_width = 30,
			auto_preview = false,
			auto_close = true,
			close_after_jump = true,
			detail = false,
			layout = "normal",
			keys = {
				toggle_or_jump = "<CR>",
				jump = "o",
				quit = "q",
			},
		},
		symbol_in_winbar = {
			enable = true,
			separator = " " .. icons.ui.Separator,
			hide_keyword = false,
			show_file = false,
			color_mode = true,
		},
		implement = {
			enable = true,
			sign = true,
			virtual_text = false,
		},
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
		beacon = {
			enable = true,
			frequency = 12,
		},
		ui = {
			title = false,
			devicon = true,
			border = "single", -- Can be single, double, rounded, solid, shadow.
			actionfix = icons.ui.Spell,
			expand = icons.ui.ArrowClosed,
			collapse = icons.ui.ArrowOpen,
			code_action = icons.ui.CodeAction,
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
	})
end
