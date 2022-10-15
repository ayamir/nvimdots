local config = {}

function config.nvim_lsp()
	require("modules.completion.lsp")
end

function config.lspsaga()
	local icon = require("modules.ui.icons")

	local function set_sidebar_icons()
		-- Set icons for sidebar.
		local diagnostic_icons = {
			Error = icon.diagnostics.Error_alt,
			Warn = icon.diagnostics.Warning_alt,
			Info = icon.diagnostics.Information_alt,
			Hint = icon.diagnostics.Hint_alt,
		}
		for type, diag_icon in pairs(diagnostic_icons) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = diag_icon, texthl = hl })
		end
	end

	local function get_palette()
		if vim.g.colors_name == "catppuccin" then
			-- If the colorscheme is catppuccin then use the palette.
			return require("catppuccin.palettes").get_palette()
		else
			-- Default behavior: return lspsaga's default palette.
			local palette = require("lspsaga.lspkind").colors
			palette.peach = palette.orange
			palette.flamingo = palette.orange
			palette.rosewater = palette.yellow
			palette.mauve = palette.violet
			palette.sapphire = palette.blue
			palette.maroon = palette.orange

			return palette
		end
	end

	set_sidebar_icons()

	local colors = get_palette()

	require("lspsaga").init_lsp_saga({
		diagnostic_header = {
			icon.diagnostics.Error_alt .. " ",
			icon.diagnostics.Warning_alt .. " ",
			icon.diagnostics.Information_alt .. " ",
			icon.diagnostics.Hint_alt .. " ",
		},
		custom_kind = {
			Class = { icon.kind.Class .. " ", colors.yellow },
			Constant = { icon.kind.Constant .. " ", colors.peach },
			Constructor = { icon.kind.Constructor .. " ", colors.sapphire },
			Enum = { icon.kind.Enum .. " ", colors.yellow },
			EnumMember = { icon.kind.EnumMember .. " ", colors.teal },
			Event = { icon.kind.Event .. " ", colors.yellow },
			Field = { icon.kind.Field .. " ", colors.teal },
			File = { icon.kind.File .. " ", colors.rosewater },
			Function = { icon.kind.Function .. " ", colors.blue },
			Interface = { icon.kind.Interface .. " ", colors.yellow },
			Key = { icon.kind.Keyword .. " ", colors.red },
			Method = { icon.kind.Method .. " ", colors.blue },
			Module = { icon.kind.Module .. " ", colors.blue },
			Namespace = { icon.kind.Namespace .. " ", colors.blue },
			Number = { icon.kind.Number .. " ", colors.peach },
			Operator = { icon.kind.Operator .. " ", colors.sky },
			Package = { icon.kind.Package .. " ", colors.blue },
			Property = { icon.kind.Property .. " ", colors.teal },
			Struct = { icon.kind.Struct .. " ", colors.yellow },
			TypeParameter = { icon.kind.TypeParameter .. " ", colors.maroon },
			Variable = { icon.kind.Variable .. " ", colors.peach },
			-- Type
			Array = { icon.type.Array .. " ", colors.peach },
			Boolean = { icon.type.Boolean .. " ", colors.peach },
			Null = { icon.type.Null .. " ", colors.yellow },
			Object = { icon.type.Object .. " ", colors.yellow },
			String = { icon.type.String .. " ", colors.green },
			-- ccls-specific icons.
			TypeAlias = { icon.kind.TypeAlias .. " ", colors.green },
			Parameter = { icon.kind.Parameter .. " ", colors.blue },
			StaticMethod = { icon.kind.StaticMethod .. " ", colors.peach },
			Macro = { icon.kind.Macro .. " ", colors.red },
		},
		symbol_in_winbar = {
			enable = true,
			in_custom = false,
			separator = " " .. icon.ui.Separator .. " ",
			show_file = false,
			-- define how to customize filename, eg: %:., %
			-- if not set, use default value `%:t`
			-- more information see `vim.fn.expand` or `expand`
			-- ## only valid after set `show_file = true`
			file_formatter = "",
			click_support = function(node, clicks, button, modifiers)
				-- To see all avaiable details: vim.pretty_print(node)
				local st = node.range.start
				local en = node.range["end"]
				if button == "l" then
					if clicks == 2 then
					-- double left click to do nothing
					else -- jump to node's starting line+char
						vim.fn.cursor(st.line + 1, st.character + 1)
					end
				elseif button == "r" then
					if modifiers == "s" then
						print("lspsaga") -- shift right click to print "lspsaga"
					end -- jump to node's ending line+char
					vim.fn.cursor(en.line + 1, en.character + 1)
				elseif button == "m" then
					-- middle click to visual select node
					vim.fn.cursor(st.line + 1, st.character + 1)
					vim.api.nvim_command([[normal v]])
					vim.fn.cursor(en.line + 1, en.character + 1)
				end
			end,
		},
	})
end

function config.cmp()
	local icon = require("modules.ui.icons")

	-- vim.api.nvim_command([[packadd cmp-tabnine]])
	local t = function(str)
		return vim.api.nvim_replace_termcodes(str, true, true, true)
	end

	local has_words_before = function()
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
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
				border = border("CmpBorder"),
				winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
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
			format = lspkind.cmp_format({
				mode = "symbol_text",
				maxwidth = 50,
				ellipsis_char = "...",
				-- symbol_map = { Copilot = "" },
				symbol_map = vim.tbl_deep_extend("force", icon.kind, icon.cmp, icon.type),
			}),
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
				elseif has_words_before() then
					cmp.complete()
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

return config
