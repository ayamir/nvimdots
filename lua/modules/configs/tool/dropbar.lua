return function()
	local icons = {
		kind = require("modules.utils.icons").get("kind", true),
		type = require("modules.utils.icons").get("type", true),
		misc = require("modules.utils.icons").get("misc", true),
		ui = require("modules.utils.icons").get("ui", true),
	}

	require("modules.utils").load_plugin("dropbar", {
		bar = {
			hover = false,
			truncate = true,
			pick = { pivots = "etovxqpdygfblzhckisuran" },
		},
		sources = {
			path = {
				relative_to = function()
					-- Only show the leaf filename in dropbar
					return vim.fn.expand("%:p:h")
				end,
			},
			terminal = {
				name = function(buf)
					local name = vim.api.nvim_buf_get_name(buf)
					local term = select(2, require("toggleterm.terminal").identify(name))
					-- Trying to "snag" a display name from toggleterm
					if term then
						return term.display_name or term.name
					else
						return name
					end
				end,
			},
		},
		icons = {
			enable = true,
			kinds = {
				symbols = {
					-- Type
					Array = icons.type.Array,
					Boolean = icons.type.Boolean,
					Null = icons.type.Null,
					Number = icons.type.Number,
					Object = icons.type.Object,
					String = icons.type.String,
					Text = icons.type.String,

					-- Kind
					BreakStatement = icons.kind.Break,
					Call = icons.kind.Call,
					CaseStatement = icons.kind.Case,
					Class = icons.kind.Class,
					Color = icons.kind.Color,
					Constant = icons.kind.Constant,
					Constructor = icons.kind.Constructor,
					ContinueStatement = icons.kind.Continue,
					Declaration = icons.kind.Declaration,
					Delete = icons.kind.Delete,
					DoStatement = icons.kind.Loop,
					Enum = icons.kind.Enum,
					EnumMember = icons.kind.EnumMember,
					Event = icons.kind.Event,
					Field = icons.kind.Field,
					File = icons.kind.File,
					ForStatement = icons.kind.Loop,
					Function = icons.kind.Function,
					Identifier = icons.kind.Variable,
					Interface = icons.kind.Interface,
					Keyword = icons.kind.Keyword,
					List = icons.kind.List,
					Lsp = icons.misc.LspAvailable,
					Method = icons.kind.Method,
					Module = icons.kind.Module,
					Namespace = icons.kind.Namespace,
					Operator = icons.kind.Operator,
					Package = icons.kind.Package,
					Pair = icons.kind.List,
					Property = icons.kind.Property,
					Reference = icons.kind.Reference,
					Regex = icons.kind.Regex,
					Repeat = icons.kind.Loop,
					Scope = icons.kind.Statement,
					Snippet = icons.kind.Snippet,
					Statement = icons.kind.Statement,
					Struct = icons.kind.Struct,
					SwitchStatement = icons.kind.Switch,
					Type = icons.kind.Interface,
					TypeParameter = icons.kind.TypeParameter,
					Unit = icons.kind.Unit,
					Value = icons.kind.Value,
					Variable = icons.kind.Variable,
					WhileStatement = icons.kind.Loop,

					-- Microsoft-specific icons
					Folder = icons.kind.Folder,

					-- ccls-specific icons
					Macro = icons.kind.Macro,
					Terminal = icons.kind.Terminal,
				},
			},
			ui = {
				bar = { separator = "  " },
				menu = { indicator = icons.ui.ArrowClosed },
			},
		},
	})
end
