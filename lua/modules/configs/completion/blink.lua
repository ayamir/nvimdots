---@module 'blink.cmp'
---@type blink.cmp.Config
local opts = {
	-- 'default' for mappings similar to built-in completion
	-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
	-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
	-- See the full "keymap" documentation for information on defining your own keymap.
	keymap = {
		preset = "super-tab",
		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
		["<C-p>"] = { "select_prev", "fallback" },
		["<C-n>"] = { "select_next", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = {
			function(cmp)
				if cmp.snippet_active() then
					return cmp.accept()
				else
					return cmp.select_and_accept()
				end
			end,
			"snippet_forward",
			"fallback",
		},
		["<S-Tab>"] = { "snippet_backward", "fallback" },
		["<C-c>"] = { "cancel", "hide", "fallback" },

		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-h>"] = { "scroll_documentation_up", "fallback" },
		["<C-l>"] = { "scroll_documentation_down", "fallback" },
		["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
	},
	---@type blink.cmp.CmdlineConfig
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
		keymap = {
			preset = "cmdline",
			["<Tab>"] = { "select_next", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
			["<CR>"] = { "accept_and_enter", "fallback" },
			["<C-c>"] = { "cancel", "hide", "fallback" },
		},
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
			ghost_text = { enabled = true },
		},
	},
	term = {
		enabled = false,
	},

	appearance = {
		nerd_font_variant = "normal",
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
		list = {
			selection = {
				preselect = true,
				auto_insert = false,
			},
		},
		menu = {
			auto_show = true,
			border = "rounded",
			draw = {
				treesitter = { "lsp" },
				columns = {
					{ "label", "label_description", gap = 1 },
					{ "kind_icon", "kind", gap = 1 },
					{ "source_name" },
				},
				components = {
					label = {
						text = function(ctx)
							return require("colorful-menu").blink_components_text(ctx)
						end,
						highlight = function(ctx)
							return require("colorful-menu").blink_components_highlight(ctx)
						end,
					},
				},
			},
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 500,
			treesitter_highlighting = true,
			window = {
				border = "single",
			},
		},
		ghost_text = {
			enabled = true,
			show_with_selection = true,
			show_with_menu = true,
		},
	},

	sources = {
		default = { "lazydev", "lsp", "path", "snippets", "buffer", "ripgrep" },
		providers = {
			lazydev = {
				module = "lazydev.integrations.blink",
				name = "LazyDev",
				score_offset = 100,
			},
			buffer = {
				score_offset = -10,
				max_items = 3,
				opts = {
					get_bufnrs = function()
						return vim.tbl_filter(function(bufnr)
							return vim.bo[bufnr].buftype == ""
						end, vim.api.nvim_list_bufs())
					end,
				},
			},
			path = {
				-- When typing a path, I would get snippets and text in the
				-- suggestions, I want those to show only if there are no path
				-- suggestions
				fallbacks = { "snippets", "buffer" },
				opts = {
					trailing_slash = false,
					label_trailing_slash = true,
					get_cwd = function(context)
						return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
					end,
					show_hidden_files_by_default = true,
				},
			},
			ripgrep = {
				module = "blink-ripgrep",
				name = "Ripgrep",
				---@module "blink-ripgrep"
				---@type blink-ripgrep.Options
				opts = {
					prefix_min_len = 2,
					context_size = 5,
					max_filesize = "100K",
				},
				score_offset = -15,
				max_items = 3,
			},
		},
	},
	snippets = {
		preset = "luasnip",
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
}

return function()
	require("modules.utils").load_plugin("blink.cmp", opts)
end
