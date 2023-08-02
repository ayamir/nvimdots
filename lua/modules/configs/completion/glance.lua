return function()
	local icons = { ui = require("modules.utils.icons").get("ui", true) }
	local glance = require("glance")
	local actions = glance.actions

	glance.setup({
		height = 20,
		zindex = 50,
		preview_win_opts = {
			cursorline = true,
			number = true,
			wrap = true,
		},
		border = {
			enable = require("core.settings").transparent_background,
			top_char = "―",
			bottom_char = "―",
		},
		list = {
			position = "right",
			width = 0.33, -- 33% width relative to the active window, min 0.1, max 0.5
		},
		folds = {
			folded = true, -- Automatically fold list on startup
			fold_closed = icons.ui.ArrowClosed,
			fold_open = icons.ui.ArrowOpen,
		},
		indent_lines = { enable = true },
		winbar = { enable = true },
		mappings = {
			list = {
				["k"] = actions.previous,
				["j"] = actions.next,
				["<Up>"] = actions.previous,
				["<Down>"] = actions.next,
				["<S-Tab>"] = actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list
				["<Tab>"] = actions.next_location, -- Bring the cursor to the next location skipping groups in the list
				["<C-u>"] = actions.preview_scroll_win(8),
				["<C-d>"] = actions.preview_scroll_win(-8),
				["<CR>"] = actions.jump,
				["v"] = actions.jump_vsplit,
				["s"] = actions.jump_split,
				["t"] = actions.jump_tab,
				["c"] = actions.close_fold,
				["o"] = actions.open_fold,
				["[]"] = actions.enter_win("preview"), -- Focus preview window
				["q"] = actions.close,
				["Q"] = actions.close,
				["<Esc>"] = actions.close,
				["gq"] = actions.quickfix,
			},
			preview = {
				["Q"] = actions.close,
				["<C-p>"] = actions.previous_location,
				["<C-n>"] = actions.next_location,
				["[]"] = actions.enter_win("list"), -- Focus list window
			},
		},
		hooks = {
			before_open = function(results, open, jump, method)
				if #results == 0 then
					vim.notify(
						"This method is not supported by any of the servers registered for the current buffer",
						vim.log.levels.WARN,
						{ title = "Glance" }
					)
				elseif method == "references" then
					if #results == 1 then
						vim.notify(
							"The identifier under cursor is the only one found",
							vim.log.levels.INFO,
							{ title = "Glance" }
						)
					else
						open(results)
					end
				else
					jump(results[1])
				end
			end,
		},
	})

	-- Override LSP handler functions
	-- stylua: ignore start
	-- luacheck: push ignore 212
	vim.lsp.buf.references = function(...) glance.open("references") end
	vim.lsp.buf.definition = function(...) glance.open("definitions") end
	vim.lsp.buf.type_definition = function(...) glance.open("type_definitions") end
	vim.lsp.buf.implementations = function(...) glance.open("implementations") end
	-- luacheck: pop
	-- stylua: ignore end
end
