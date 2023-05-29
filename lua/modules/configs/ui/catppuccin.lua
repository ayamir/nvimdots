return function()
	local transparent_background = require("core.settings").transparent_background
	local clear = {}

	require("catppuccin").setup({
		flavour = "mocha", -- Can be one of: latte, frappe, macchiato, mocha
		background = { light = "latte", dark = "mocha" },
		dim_inactive = {
			enabled = false,
			-- Dim inactive splits/windows/buffers.
			-- NOT recommended if you use old palette (a.k.a., mocha).
			shade = "dark",
			percentage = 0.15,
		},
		transparent_background = transparent_background,
		show_end_of_buffer = false, -- show the '~' characters after the end of buffers
		term_colors = true,
		compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
		styles = {
			comments = { "italic" },
			properties = { "italic" },
			functions = { "bold" },
			keywords = { "italic" },
			operators = { "bold" },
			conditionals = { "bold" },
			loops = { "bold" },
			booleans = { "bold", "italic" },
			numbers = {},
			types = {},
			strings = {},
			variables = {},
		},
		integrations = {
			treesitter = true,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
				},
			},
			aerial = false,
			alpha = false,
			barbar = false,
			beacon = false,
			cmp = true,
			coc_nvim = false,
			dap = { enabled = true, enable_ui = true },
			dashboard = false,
			fern = false,
			fidget = true,
			gitgutter = false,
			gitsigns = true,
			harpoon = false,
			hop = true,
			illuminate = true,
			indent_blankline = { enabled = true, colored_indent_levels = false },
			leap = false,
			lightspeed = false,
			lsp_saga = true,
			lsp_trouble = true,
			markdown = true,
			mason = true,
			mini = false,
			navic = { enabled = false },
			neogit = false,
			neotest = false,
			neotree = { enabled = false, show_root = true, transparent_panel = false },
			noice = false,
			notify = true,
			nvimtree = true,
			overseer = false,
			pounce = false,
			semantic_tokens = true,
			symbols_outline = false,
			telekasten = false,
			telescope = true,
			treesitter_context = false,
			ts_rainbow = true,
			vim_sneak = false,
			vimwiki = false,
			which_key = true,
		},
		color_overrides = {
			mocha = {
				rosewater = "#F5E0DC",
				flamingo = "#F2CDCD",
				mauve = "#DDB6F2",
				pink = "#F5C2E7",
				red = "#F28FAD",
				maroon = "#E8A2AF",
				peach = "#F8BD96",
				yellow = "#FAE3B0",
				green = "#ABE9B3",
				blue = "#96CDFB",
				sky = "#89DCEB",
				teal = "#B5E8E0",
				lavender = "#C9CBFF",

				text = "#D9E0EE",
				subtext1 = "#BAC2DE",
				subtext0 = "#A6ADC8",
				overlay2 = "#C3BAC6",
				overlay1 = "#988BA2",
				overlay0 = "#6E6C7E",
				surface2 = "#6E6C7E",
				surface1 = "#575268",
				surface0 = "#302D41",

				base = "#1E1E2E",
				mantle = "#1A1826",
				crust = "#161320",
			},
		},
		highlight_overrides = {
			---@param cp palette
			mocha = function(cp)
				return {
					-- For base configs
					NormalFloat = { fg = cp.text, bg = transparent_background and cp.none or cp.base },
					-- FloatBorder = { fg = cp.blue },
					CursorLineNr = { fg = cp.green },
					Search = { bg = cp.surface1, fg = cp.pink, style = { "bold" } },
					IncSearch = { bg = cp.pink, fg = cp.surface1 },

					-- For native lsp configs
					DiagnosticVirtualTextError = { bg = cp.none },
					DiagnosticVirtualTextWarn = { bg = cp.none },
					DiagnosticVirtualTextInfo = { bg = cp.none },
					DiagnosticVirtualTextHint = { fg = cp.rosewater, bg = cp.none },

					DiagnosticHint = { fg = cp.rosewater },
					LspDiagnosticsDefaultHint = { fg = cp.rosewater },
					LspDiagnosticsHint = { fg = cp.rosewater },
					LspDiagnosticsVirtualTextHint = { fg = cp.rosewater },
					LspDiagnosticsUnderlineHint = { sp = cp.rosewater },

					-- For fidget
					FidgetTask = { bg = cp.none, fg = cp.surface2 },
					FidgetTitle = { fg = cp.blue, style = { "bold" } },

					-- For nvim-tree
					NvimTreeRootFolder = { fg = cp.pink },

					-- For trouble.nvim
					TroubleNormal = { bg = transparent_background and cp.none or cp.base },

					-- For lsp semantic tokens
					["@lsp.type.comment"] = { fg = cp.overlay0 },
					["@lsp.type.enum"] = { link = "@type" },
					["@lsp.type.type"] = { link = "@type" },
					["@lsp.type.property"] = { link = "@property" },
					["@lsp.type.property.c"] = { link = "@property.cpp" },
					["@lsp.type.property.cpp"] = { link = "@property.cpp" },
					["@lsp.type.macro"] = { link = "@constant" },
					["@lsp.typemod.function.defaultLibrary"] = { fg = cp.blue, style = { "bold", "italic" } },
					["@lsp.typemod.function.defaultLibrary.c"] = { fg = cp.blue, style = { "bold" } },
					["@lsp.typemod.function.defaultLibrary.cpp"] = { fg = cp.blue, style = { "bold" } },
					["@lsp.typemod.method.defaultLibrary"] = { link = "@lsp.typemod.function.defaultLibrary" },
					["@lsp.typemod.variable.defaultLibrary"] = { fg = cp.flamingo },

					-- For treesitter
					-- Comment = { fg = cp.overlay0 },
					-- Error = { fg = cp.red },
					-- PreProc = { fg = cp.pink },
					-- Operator = { fg = cp.sky },

					["@punctuation.delimiter"] = { fg = cp.teal },
					["@punctuation.bracket"] = { fg = cp.overlay2 },
					["@punctuation.special"] = { fg = cp.maroon },

					-- String = { fg = cp.green },
					-- ["@string.regex"] = { fg = cp.peach },
					-- ["@string.escape"] = { fg = cp.pink },
					-- ["@string.special"] = { fg = cp.blue },

					-- Character = { fg = cp.teal },
					-- SpecialChar = { link = "Special" },

					-- Boolean = { fg = cp.peach },
					-- Number = { fg = cp.peach },

					-- Function = { fg = cp.blue },
					-- ["@function.builtin"] = { fg = cp.peach },
					-- ["@function.call"] = { link = "@function" },
					-- ["@function.macro"] = { fg = cp.teal },
					["@method"] = { link = "Function" },
					-- ["@method.call"] = { link = "@method" },

					["@constructor"] = { fg = cp.lavender },
					["@parameter"] = { fg = cp.rosewater },

					Keyword = { fg = cp.red },
					["@keyword.function"] = { fg = cp.maroon },
					["@keyword.operator"] = { fg = cp.sky },
					["@keyword.return"] = { fg = cp.pink, style = clear },
					-- ["@keyword.export"] = { fg = cp.sky },

					Conditional = { fg = cp.mauve },
					Repeat = { fg = cp.mauve },
					Label = { fg = cp.rosewater },
					["@include"] = { fg = cp.teal },
					["@exception"] = { fg = cp.peach },

					-- Type = { fg = cp.yellow },
					-- ["@type.builtin"] = { fg = cp.yellow },
					-- ["@type.definition"] = { link = "@type" },
					["@type.qualifier"] = { link = "@keyword" },

					StorageClass = { link = "@keyword" },
					-- Constant = { fg = cp.peach },
					["@field"] = { fg = cp.rosewater },
					["@property"] = { fg = cp.yellow },

					-- ["@variable"] = { fg = cp.text },
					["@variable.builtin"] = { fg = cp.flamingo, style = { "italic" } },

					["@constant"] = { link = "Constant" },
					["@constant.builtin"] = { fg = cp.lavender },
					Macro = { fg = cp.mauve },

					["@namespace"] = { fg = cp.rosewater, style = clear },
					-- ["@symbol"] = { fg = cp.flamingo },

					["@text"] = { fg = cp.text },
					["@tag"] = { fg = cp.peach },
					["@tag.attribute"] = { fg = cp.mauve },
					["@tag.delimiter"] = { fg = cp.maroon },

					-- TODO: support semantic tokens

					-- ["@class"] = { fg = cp.blue },
					-- ["@struct"] = { fg = cp.blue },
					["@enum"] = { link = "@type" },
					-- ["@enumMember"] = { fg = cp.flamingo },
					-- ["@event"] = { fg = cp.flamingo },
					["@interface"] = { fg = cp.yellow },
					-- ["@modifier"] = { fg = cp.flamingo },
					-- ["@regexp"] = { fg = cp.pink },
					-- ["@typeParameter"] = { fg = cp.yellow },
					-- ["@decorator"] = { fg = cp.flamingo },

					-- ["@property.toml"] = { fg = cp.blue },
					-- ["@field.yaml"] = { fg = cp.blue },

					-- ["@label.json"] = { fg = cp.blue },

					["@function.builtin.bash"] = { fg = cp.red, style = { "italic" } },
					-- ["@parameter.bash"] = { fg = cp.yellow, style = { "italic" } },

					["@constructor.lua"] = { fg = cp.flamingo },
					["@field.lua"] = { fg = cp.lavender },

					["@constant.java"] = { fg = cp.teal },

					["@property.typescript"] = { fg = cp.lavender, style = { "italic" } },
					-- ["@constructor.typescript"] = { fg = cp.lavender },

					-- ["@constructor.tsx"] = { fg = cp.lavender },
					-- ["@tag.attribute.tsx"] = { fg = cp.mauve },

					["@type.css"] = { fg = cp.lavender },
					["@property.css"] = { fg = cp.yellow, style = { "italic" } },

					["@type.builtin.c"] = { style = clear },

					["@property.cpp"] = { fg = cp.text },
					["@type.builtin.cpp"] = { style = clear },

					-- ["@symbol"] = { fg = cp.flamingo },

					-- Misc
					gitcommitSummary = { fg = cp.rosewater, style = { "italic" } },
				}
			end,
		},
	})
end
