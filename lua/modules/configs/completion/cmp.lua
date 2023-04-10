return function()
	local icons = {
		kind = require("modules.utils.icons").get("kind"),
		type = require("modules.utils.icons").get("type"),
		cmp = require("modules.utils.icons").get("cmp"),
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

	---Handling situations where LuaSnip failed to perform any jumps
	---@param r integer @Cursor position (row) before calling LuaSnip
	---@param c integer @Cursor position (col) before calling LuaSnip
	---@param fallback function @Fallback function inherited from cmp
	local luasnip_fallback = vim.schedule_wrap(function(r, c, fallback)
		local _r, _c = unpack(vim.api.nvim_win_get_cursor(0))
		if _r == r and _c == c then
			fallback()
		end
	end)

	local cmp_window = require("cmp.utils.window")

	cmp_window.info_ = cmp_window.info
	cmp_window.info = function(self)
		local info = self:info_()
		info.scrollable = false
		return info
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

	local function cmp_kind(opts)
		if opts == nil then
			opts = {}
		end

		return function(entry, vim_item)
			if opts.before then
				vim_item = opts.before(entry, vim_item)
			end

			local symbol = opts.symbol_map[vim_item.kind]
			vim_item.kind = string.format("%s %s", symbol, vim_item.kind)

			if opts.menu ~= nil then
				vim_item.menu = opts.menu[entry.source.name]
			end

			if opts.maxwidth ~= nil then
				if opts.ellipsis_char == nil then
					vim_item.abbr = string.sub(vim_item.abbr, 1, opts.maxwidth)
				else
					local label = vim_item.abbr
					local truncated_label = vim.fn.strcharpart(label, 0, opts.maxwidth)
					if truncated_label ~= label then
						vim_item.abbr = truncated_label .. opts.ellipsis_char
					end
				end
			end
			return vim_item
		end
	end

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
				compare.lsp_scores,
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
				local kind_map = vim.tbl_deep_extend("force", icons.kind, icons.type, icons.cmp)
				local kind = cmp_kind({
					maxwidth = 50,
					symbol_map = kind_map,
				})(entry, vim_item)
				-- local strings = vim.split(kind.kind, "%s", { trimempty = true })
				kind.menu = "  ⟬ " .. kind.kind .. " ⟭"
				kind.kind = " " .. kind_map[entry.source.name] .. " "
				return kind
			end,
		},
		-- You can set mappings if you want
		mapping = cmp.mapping.preset.insert({
			["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-w>"] = cmp.mapping.close(),
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif require("luasnip").expand_or_locally_jumpable() then
					local _r, _c = unpack(vim.api.nvim_win_get_cursor(0))
					vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"))
					luasnip_fallback(_r, _c, fallback)
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
			{
				name = "treesitter",
				---@diagnostic disable-next-line: unused-local
				entry_filter = function(entry, _ctx)
					local banned_kinds = {
						"Error",
						"Comment",
					}
					local kind = entry:get_completion_item().cmp.kind_text
					if vim.tbl_contains(banned_kinds, kind) then
						return false
					end
					return true
				end,
			},
			{ name = "spell" },
			{ name = "tmux" },
			{ name = "orgmode" },
			{ name = "buffer" },
			{ name = "latex_symbols" },
			{ name = "copilot" },
			-- { name = "codeium" },
			-- { name = "cmp_tabnine" },
		},
	})
end
