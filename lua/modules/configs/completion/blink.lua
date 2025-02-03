---@module 'blink.cmp'
---@type blink.cmp.Config
local opts = {
	-- 'default' for mappings similar to built-in completion
	-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
	-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
	-- See the full "keymap" documentation for information on defining your own keymap.
	keymap = {
		preset = "default",
		["<C-n>"] = { "select_next", "fallback" },
		["<C-p>"] = { "select_prev", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-tab>"] = { "snippet_backward", "fallback" },
		["<C-c>"] = { "cancel", "hide", "fallback" },

		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<S-k>"] = { "scroll_documentation_up", "fallback" },
		["<S-j>"] = { "scroll_documentation_down", "fallback" },
		["<S-s>"] = { "show_signature", "hide_signature", "fallback" },
		cmdline = {
			preset = "enter",
			["<C-n>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<C-c>"] = { "cancel", "hide", "fallback" },
		},
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
			},
		},
		list = {
			selection = {
				preselect = false,
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
		},
	},

	sources = {
		default = { "lazydev", "lsp", "path", "snippets", "buffer", "ripgrep" },
		cmdline = function()
			local type = vim.fn.getcmdtype()
			if type == "/" or type == "?" then
				return { "buffer" }
			end
			if type == ":" or type == "@" then
				return { "cmdline", "path" }
			end
			return {}
		end,
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
