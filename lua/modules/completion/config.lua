local config = {}

function config.nvim_lsp()
	require("modules.completion.lsp")
end

function config.lspsaga()
	local icons = {
		diagnostics = require("modules.ui.icons").get("diagnostics", true),
		kind = require("modules.ui.icons").get("kind", true),
		type = require("modules.ui.icons").get("type", true),
		ui = require("modules.ui.icons").get("ui", true),
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

	local colors = require("modules.utils").get_palette()

	require("lspsaga").setup({
		preview = {
			lines_above = 1,
			lines_below = 17,
		},
		scroll_preview = {
			scroll_down = "<C-j>",
			scroll_up = "<C-k>",
		},
		request_timeout = 3000,
		finder = {
			edit = { "o", "<CR>" },
			vsplit = "s",
			split = "i",
			tabe = "t",
			quit = { "q", "<ESC>" },
		},
		definition = {
			edit = "<C-c>o",
			vsplit = "<C-c>v",
			split = "<C-c>s",
			tabe = "<C-c>t",
			quit = "q",
			close = "<Esc>",
		},
		code_action = {
			num_shortcut = true,
			keys = {
				quit = "q",
				exec = "<CR>",
			},
		},
		lightbulb = {
			enable = false,
			sign = true,
			enable_in_insert = true,
			sign_priority = 20,
			virtual_text = false,
		},
		diagnostic = {
			show_code_action = true,
			show_source = true,
			jump_num_shortcut = true,
			keys = {
				exec_action = "<CR>",
				quit = "q",
				go_action = "g",
			},
		},
		rename = {
			quit = "<C-c>",
			mark = "x",
			confirm = "<CR>",
			exec = "<CR>",
			in_select = false,
		},
		outline = {
			win_position = "right",
			win_with = "_sagaoutline",
			win_width = 30,
			show_detail = true,
			auto_preview = false,
			auto_refresh = true,
			auto_close = true,
			keys = {
				jump = "<CR>",
				expand_collapse = "u",
				quit = "q",
			},
		},
		symbol_in_winbar = {
			enable = false,
			separator = " " .. icons.ui.Separator,
			hide_keyword = true,
			show_file = false,
			color_mode = true,
		},
		beacon = {
			enable = true,
			frequency = 12,
		},
		ui = {
			theme = "round",
			border = "single", -- Can be single, double, rounded, solid, shadow.
			winblend = 0,
			expand = icons.ui.ArrowClosed,
			collapse = icons.ui.ArrowOpen,
			preview = icons.ui.Newspaper,
			code_action = icons.ui.CodeAction,
			diagnostic = icons.ui.Bug,
			incoming = icons.ui.Incoming,
			outgoing = icons.ui.Outgoing,
			kind = {
				-- Kind
				Class = { icons.kind.Class, colors.yellow },
				Constant = { icons.kind.Constant, colors.peach },
				Constructor = { icons.kind.Constructor, colors.sapphire },
				Enum = { icons.kind.Enum, colors.yellow },
				EnumMember = { icons.kind.EnumMember, colors.teal },
				Event = { icons.kind.Event, colors.yellow },
				Field = { icons.kind.Field, colors.teal },
				File = { icons.kind.File, colors.rosewater },
				Function = { icons.kind.Function, colors.blue },
				Interface = { icons.kind.Interface, colors.yellow },
				Key = { icons.kind.Keyword, colors.red },
				Method = { icons.kind.Method, colors.blue },
				Module = { icons.kind.Module, colors.blue },
				Namespace = { icons.kind.Namespace, colors.blue },
				Number = { icons.kind.Number, colors.peach },
				Operator = { icons.kind.Operator, colors.sky },
				Package = { icons.kind.Package, colors.blue },
				Property = { icons.kind.Property, colors.teal },
				Struct = { icons.kind.Struct, colors.yellow },
				TypeParameter = { icons.kind.TypeParameter, colors.maroon },
				Variable = { icons.kind.Variable, colors.peach },
				-- Type
				Array = { icons.type.Array, colors.peach },
				Boolean = { icons.type.Boolean, colors.peach },
				Null = { icons.type.Null, colors.yellow },
				Object = { icons.type.Object, colors.yellow },
				String = { icons.type.String, colors.green },
				-- ccls-specific icons.
				TypeAlias = { icons.kind.TypeAlias, colors.green },
				Parameter = { icons.kind.Parameter, colors.blue },
				StaticMethod = { icons.kind.StaticMethod, colors.peach },
				-- Microsoft-specific icons.
				Text = { icons.kind.Text, colors.green },
				Snippet = { icons.kind.Snippet, colors.mauve },
				Folder = { icons.kind.Folder, colors.blue },
				Unit = { icons.kind.Unit, colors.green },
				Value = { icons.kind.Value, colors.peach },
			},
		},
	})
end

function config.cmp()
	local icons = {
		kind = require("modules.ui.icons").get("kind", false),
		type = require("modules.ui.icons").get("type", false),
		cmp = require("modules.ui.icons").get("cmp", false),
	}
	local t = function(str)
		return vim.api.nvim_replace_termcodes(str, true, true, true)
	end

	local border = function(hl)
		return {
			{ "╭", hl },
			{ "─", hl },
			{ "╮", hl },
			{ "│", hl },
			{ "╯", hl },
			{ "─", hl },
			{ "╰", hl },
			{ "│", hl },
		}
	end

	local cmp_window = require("cmp.utils.window")

	cmp_window.info_ = cmp_window.info
	cmp_window.info = function(self)
		local info = self:info_()
		info.scrollable = false
		return info
	end

	local compare = require("cmp.config.compare")
	local lspkind = require("lspkind")
	local cmp = require("cmp")

	cmp.setup({
		window = {
			completion = {
				border = border("Normal"),
				max_width = 80,
				max_height = 20,
			},
			documentation = {
				border = border("CmpDocBorder"),
			},
		},
		sorting = {
			priority_weight = 2,
			comparators = {
				require("copilot_cmp.comparators").prioritize,
				require("copilot_cmp.comparators").score,
				-- require("cmp_tabnine.compare"),
				compare.offset,
				compare.exact,
				compare.score,
				require("cmp-under-comparator").under,
				compare.kind,
				compare.sort_text,
				compare.length,
				compare.order,
			},
		},
		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = function(entry, vim_item)
				local kind = lspkind.cmp_format({
					mode = "symbol_text",
					maxwidth = 50,
					symbol_map = vim.tbl_deep_extend("force", icons.kind, icons.type, icons.cmp),
				})(entry, vim_item)
				local strings = vim.split(kind.kind, "%s", { trimempty = true })
				kind.kind = " " .. strings[1] .. " "
				kind.menu = "    (" .. strings[2] .. ")"
				return kind
			end,
		},
		-- You can set mappings if you want
		mapping = cmp.mapping.preset.insert({
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-e>"] = cmp.mapping.close(),
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif require("luasnip").expand_or_jumpable() then
					vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"), "")
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif require("luasnip").jumpable(-1) then
					vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
				else
					fallback()
				end
			end, { "i", "s" }),
		}),
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		-- You should specify your *installed* sources.
		sources = {
			{ name = "nvim_lsp" },
			{ name = "nvim_lua" },
			{ name = "luasnip" },
			{ name = "path" },
			{ name = "spell" },
			{ name = "tmux" },
			{ name = "orgmode" },
			{ name = "buffer" },
			{ name = "latex_symbols" },
			{ name = "copilot" },
			-- { name = "cmp_tabnine" },
		},
	})
end

function config.luasnip()
	local snippet_path = os.getenv("HOME") .. "/.config/nvim/my-snippets/"
	if not vim.tbl_contains(vim.opt.rtp:get(), snippet_path) then
		vim.opt.rtp:append(snippet_path)
	end

	require("luasnip").config.set_config({
		history = true,
		updateevents = "TextChanged,TextChangedI",
		delete_check_events = "TextChanged,InsertLeave",
	})
	require("luasnip.loaders.from_lua").lazy_load()
	require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip.loaders.from_snipmate").lazy_load()
end

-- function config.tabnine()
-- 	local tabnine = require("cmp_tabnine.config")
-- 	tabnine:setup({ max_line = 1000, max_num_results = 20, sort = true })
-- end

function config.autopairs()
	require("nvim-autopairs").setup({})

	-- If you want insert `(` after select function or method item
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	local cmp = require("cmp")
	local handlers = require("nvim-autopairs.completion.handlers")
	cmp.event:on(
		"confirm_done",
		cmp_autopairs.on_confirm_done({
			filetypes = {
				-- "*" is an alias to all filetypes
				["*"] = {
					["("] = {
						kind = {
							cmp.lsp.CompletionItemKind.Function,
							cmp.lsp.CompletionItemKind.Method,
						},
						handler = handlers["*"],
					},
				},
				-- Disable for tex
				tex = false,
			},
		})
	)
end

function config.mason_install()
	require("mason-tool-installer").setup({

		-- a list of all tools you want to ensure are installed upon
		-- start; they should be the names Mason uses for each tool
		ensure_installed = {
			-- you can turn off/on auto_update per tool
			-- "editorconfig-checker",

			"stylua",

			"black",

			"prettier",

			"shellcheck",
			"shfmt",

			-- "vint",
		},

		-- if set to true this will check each tool for updates. If updates
		-- are available the tool will be updated.
		-- Default: false
		auto_update = false,

		-- automatically install / update on startup. If set to false nothing
		-- will happen on startup. You can use `:MasonToolsUpdate` to install
		-- tools and check for updates.
		-- Default: true
		run_on_start = true,
	})
end

function config.copilot()
	vim.defer_fn(function()
		require("copilot").setup({
			cmp = {
				enabled = true,
				method = "getCompletionsCycling",
			},
			panel = {
				-- if true, it can interfere with completions in copilot-cmp
				enabled = false,
			},
			suggestion = {
				-- if true, it can interfere with completions in copilot-cmp
				enabled = false,
			},
			filetypes = {
				["dap-repl"] = false,
				["big_file_disabled_ft"] = false,
			},
		})
	end, 100)
end

return config
