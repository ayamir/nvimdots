return function()
	local icons = {
		kind = require("modules.utils.icons").get("kind"),
		type = require("modules.utils.icons").get("type"),
		cmp = require("modules.utils.icons").get("cmp"),
	}
	local use_copilot = require("core.settings").use_copilot

	local source_labels = {
		copilot = "[CPLT]",
		buffer = "[BUF]",
		lsp = "[LSP]",
		path = "[PATH]",
		tmux = "[TMUX]",
		latex_symbols = "[LTEX]",
		snippets = "[SNIP]",
		spell = "[SPELL]",
	}

	local sources_default = { "lsp", "snippets", "path", "buffer", "spell", "tmux", "latex_symbols" }
	if use_copilot then
		table.insert(sources_default, 1, "copilot")
	end

	require("modules.utils").load_plugin("blink.cmp", {
		snippets = { preset = "luasnip" },
		cmdline = { enabled = true },
		appearance = { nerd_font_variant = "normal" },
		fuzzy = { implementation = "prefer_rust" },

		sources = {
			default = sources_default,
			providers = {
				lsp = { max_items = 350 },
				buffer = {
					opts = {
						get_bufnrs = function()
							return vim.api.nvim_buf_line_count(0) < 15000 and vim.api.nvim_list_bufs() or {}
						end,
					},
				},
				copilot = {
					name = "Copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
					opts = {
						max_completions = 3,
						max_attempts = 4,
					},
				},
				spell = {
					name = "Spell",
					module = "blink.compat.source",
					opts = { cmp_name = "spell" },
				},
				tmux = {
					name = "Tmux",
					module = "blink.compat.source",
					opts = { cmp_name = "tmux" },
				},
				latex_symbols = {
					name = "LaTeX",
					module = "blink.compat.source",
					opts = { cmp_name = "latex_symbols" },
				},
			},
		},

		keymap = {
			preset = "none",
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			["<C-d>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<C-w>"] = { "cancel", "fallback" },
			["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
			["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			["<CR>"] = { "accept", "fallback" },
		},

		completion = {
			ghost_text = { enabled = false },
			list = {
				max_items = 120,
				selection = { preselect = false, auto_insert = false },
			},
			menu = {
				border = "single",
				winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:PmenuSel",
				scrollbar = false,
				draw = {
					padding = { 1, 1 },
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon" },
						{ "kind", "source_name", gap = 1 },
					},
					components = {
						kind_icon = {
							text = function(ctx)
								local lspkind_icons = vim.tbl_deep_extend("force", icons.kind, icons.type, icons.cmp)
								return lspkind_icons[ctx.kind] or icons.cmp.undefined
							end,
						},
						kind = {
							text = function(ctx)
								return ctx.kind or ""
							end,
							highlight = function(ctx)
								return ctx.kind
							end,
						},
						label = {
							text = function(ctx)
								local label = ctx.label
								local truncated = vim.fn.strcharpart(label, 0, 80)
								return truncated ~= label and (truncated .. "...") or label
							end,
						},
						source_name = {
							text = function(ctx)
								return source_labels[ctx.source_id] or "[BTN]"
							end,
							highlight = "Comment",
						},
					},
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				window = {
					border = "single",
					winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
				},
			},
		},
	})
end
