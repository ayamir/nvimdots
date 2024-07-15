return function()
	local icons = {
		kind = require("modules.utils.icons").get("kind"),
		type = require("modules.utils.icons").get("type"),
		cmp = require("modules.utils.icons").get("cmp"),
	}

	local border = function(hl)
		return {
			{ "┌", hl },
			{ "─", hl },
			{ "┐", hl },
			{ "│", hl },
			{ "┘", hl },
			{ "─", hl },
			{ "└", hl },
			{ "│", hl },
		}
	end

	local compare = require("cmp.config.compare")
	compare.lsp_scores = function(entry1, entry2)
		local diff
		if entry1.completion_item.score and entry2.completion_item.score then
			diff = (entry2.completion_item.score * entry2.score) - (entry1.completion_item.score * entry1.score)
		else
			diff = entry2.score - entry1.score
		end
		return (diff < 0)
	end

	local use_copilot = require("core.settings").use_copilot
	local comparators = use_copilot == true
			and {
				require("copilot_cmp.comparators").prioritize,
				require("copilot_cmp.comparators").score,
				-- require("cmp_tabnine.compare"),
				compare.offset, -- Items closer to cursor will have lower priority
				compare.exact,
				-- compare.scopes,
				compare.lsp_scores,
				compare.sort_text,
				compare.score,
				compare.recently_used,
				-- compare.locality, -- Items closer to cursor will have higher priority, conflicts with `offset`
				require("cmp-under-comparator").under,
				compare.kind,
				compare.length,
				compare.order,
			}
		or {
			-- require("cmp_tabnine.compare"),
			compare.offset, -- Items closer to cursor will have lower priority
			compare.exact,
			-- compare.scopes,
			compare.lsp_scores,
			compare.sort_text,
			compare.score,
			compare.recently_used,
			-- compare.locality, -- Items closer to cursor will have higher priority, conflicts with `offset`
			require("cmp-under-comparator").under,
			compare.kind,
			compare.length,
			compare.order,
		}

	local cmp = require("cmp")
	require("modules.utils").load_plugin("cmp", {
		preselect = cmp.PreselectMode.None,
		window = {
			completion = {
				border = border("PmenuBorder"),
				winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,Search:PmenuSel",
				scrollbar = false,
			},
			documentation = {
				border = border("CmpDocBorder"),
				winhighlight = "Normal:CmpDoc",
			},
		},
		sorting = {
			priority_weight = 2,
			comparators = comparators,
		},
		formatting = {
			fields = { "abbr", "kind", "menu" },
			format = function(entry, vim_item)
				local lspkind_icons = vim.tbl_deep_extend("force", icons.kind, icons.type, icons.cmp)
				-- load lspkind icons
				vim_item.kind =
					string.format(" %s  %s", lspkind_icons[vim_item.kind] or icons.cmp.undefined, vim_item.kind or "")

				-- set up labels for completion entries
				vim_item.menu = setmetatable({
					cmp_tabnine = "[TN]",
					copilot = "[CPLT]",
					buffer = "[BUF]",
					orgmode = "[ORG]",
					nvim_lsp = "[LSP]",
					nvim_lua = "[LUA]",
					path = "[PATH]",
					tmux = "[TMUX]",
					treesitter = "[TS]",
					latex_symbols = "[LTEX]",
					luasnip = "[SNIP]",
					spell = "[SPELL]",
				}, {
					__index = function()
						return "[BTN]" -- builtin/unknown source names
					end,
				})[entry.source.name]

				-- cut down long results
				local label = vim_item.abbr
				local truncated_label = vim.fn.strcharpart(label, 0, 80)
				if truncated_label ~= label then
					vim_item.abbr = truncated_label .. "..."
				end

				-- deduplicate results from nvim_lsp
				if entry.source.name == "nvim_lsp" then
					vim_item.dup = 0
				end

				return vim_item
			end,
		},
		matching = {
			disallow_partial_fuzzy_matching = false,
		},
		performance = {
			async_budget = 1,
			max_view_entries = 120,
		},
		-- You can set mappings if you want
		mapping = cmp.mapping.preset.insert({
			["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
			["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-w>"] = cmp.mapping.abort(),
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
				elseif require("luasnip").expand_or_locally_jumpable() then
					require("luasnip").expand_or_jump()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
				elseif require("luasnip").jumpable(-1) then
					require("luasnip").jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
			["<CR>"] = cmp.mapping({
				i = function(fallback)
					if cmp.visible() and cmp.get_active_entry() then
						cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false })
					else
						fallback()
					end
				end,
				s = cmp.mapping.confirm({ select = true }),
				c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
			}),
		}),
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		-- You should specify your *installed* sources.
		sources = {
			{ name = "nvim_lsp", max_item_count = 350 },
			{ name = "nvim_lua" },
			{ name = "luasnip" },
			{ name = "path" },
			{ name = "treesitter" },
			{ name = "spell" },
			{ name = "tmux" },
			{ name = "orgmode" },
			{
				name = "buffer",
				option = {
					get_bufnrs = function()
						return vim.api.nvim_buf_line_count(0) < 7500 and vim.api.nvim_list_bufs() or {}
					end,
				},
			},
			{ name = "latex_symbols" },
			{ name = "copilot" },
			-- { name = "codeium" },
			-- { name = "cmp_tabnine" },
		},
		experimental = {
			ghost_text = {
				hl_group = "Whitespace",
			},
		},
	})
end
