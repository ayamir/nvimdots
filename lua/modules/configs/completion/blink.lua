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
		lazydev = "[LAZY]",
		lsp = "[LSP]",
		path = "[PATH]",
		ripgrep = "[RG]",
		tmux = "[TMUX]",
		latex_symbols = "[LTEX]",
		snippets = "[SNIP]",
		spell = "[SPELL]",
	}

	local sources_default =
		{ "lazydev", "lsp", "snippets", "path", "buffer", "ripgrep", "spell", "tmux", "latex_symbols" }
	if use_copilot then
		table.insert(sources_default, 1, "copilot")
	end

	require("modules.utils").load_plugin("blink.cmp", {
		snippets = { preset = "luasnip" },
		cmdline = {
			enabled = true,
			sources = function()
				local type = vim.fn.getcmdtype()
				if type == "/" or type == "?" then
					return { "buffer" }
				end
				if type == ":" or type == "@" then
					return { "cmdline", "path" }
				end
				return {}
			end,
			completion = {
				list = { selection = { preselect = true, auto_insert = true } },
				menu = {
					auto_show = true,
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind", gap = 1 },
							{ "source_name" },
						},
					},
				},
				ghost_text = { enabled = false },
			},
		},
		term = { enabled = false },
		appearance = { nerd_font_variant = "normal" },
		fuzzy = { implementation = "prefer_rust_with_warning" },

		sources = {
			default = sources_default,
			providers = {
				lsp = { max_items = 350 },
				lazydev = {
					module = "lazydev.integrations.blink",
					name = "LazyDev",
					score_offset = 100,
				},
				buffer = {
					opts = {
						get_bufnrs = function()
							return vim.api.nvim_buf_line_count(0) < 15000 and vim.api.nvim_list_bufs() or {}
						end,
					},
				},
				ripgrep = {
					module = "blink-ripgrep",
					name = "Ripgrep",
					opts = {
						prefix_min_len = 2,
						backend = {
							use = "ripgrep",
							ripgrep = {
								context_size = 5,
								max_filesize = "1M",
							},
						},
					},
					score_offset = -15,
					max_items = 3,
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
			keyword = {
				range = "full",
			},
			accept = {
				auto_brackets = {
					enabled = true,
					kind_resolution = {
						enabled = true,
					},
					semantic_token_resolution = {
						enabled = true,
						blocked_filetypes = { "java" },
					},
				},
			},
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
								return require("colorful-menu").blink_components_text(ctx)
							end,
							highlight = function(ctx)
								return require("colorful-menu").blink_components_highlight(ctx)
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
				treesitter_highlighting = true,
				window = {
					border = "single",
					winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
				},
			},
		},
		signature = {
			enabled = true,
			trigger = {
				show_on_insert = true,
			},
			window = {
				border = "single",
				treesitter_highlighting = true,
				show_documentation = true,
			},
		},
	})
end
