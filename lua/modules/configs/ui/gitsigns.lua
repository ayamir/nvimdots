return function()
	require("gitsigns").setup({
		signs = {
			add = {
				hl = "GitSignsAdd",
				text = "│",
				numhl = "GitSignsAddNr",
				linehl = "GitSignsAddLn",
			},
			change = {
				hl = "GitSignsChange",
				text = "│",
				numhl = "GitSignsChangeNr",
				linehl = "GitSignsChangeLn",
			},
			delete = {
				hl = "GitSignsDelete",
				text = "_",
				numhl = "GitSignsDeleteNr",
				linehl = "GitSignsDeleteLn",
			},
			topdelete = {
				hl = "GitSignsDelete",
				text = "‾",
				numhl = "GitSignsDeleteNr",
				linehl = "GitSignsDeleteLn",
			},
			changedelete = {
				hl = "GitSignsChange",
				text = "~",
				numhl = "GitSignsChangeNr",
				linehl = "GitSignsChangeLn",
			},
		},
		on_attach = function(bufnr)
			local bind = require("keymap.bind")

			bind.nvim_load_mapping({
				["n|]g"] = bind.map_callback(function()
					if vim.wo.diff then
						return "]g"
					end
					vim.schedule(function()
						require("gitsigns.actions").next_hunk()
					end)
					return "<Ignore>"
				end)
					:with_buffer(bufnr)
					:with_expr()
					:with_desc("git: Goto next hunk"),
				["n|[g"] = bind.map_callback(function()
					if vim.wo.diff then
						return "[g"
					end
					vim.schedule(function()
						require("gitsigns.actions").prev_hunk()
					end)
					return "<Ignore>"
				end)
					:with_buffer(bufnr)
					:with_expr()
					:with_desc("git: Goto prev hunk"),
				["n|<leader>hs"] = bind.map_callback(function()
					require("gitsigns.actions").stage_hunk()
				end)
					:with_buffer(bufnr)
					:with_desc("git: Stage hunk"),
				["v|<leader>hs"] = bind.map_callback(function()
					require("gitsigns.actions").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end)
					:with_buffer(bufnr)
					:with_desc("git: Stage hunk"),
				["n|<leader>hu"] = bind.map_callback(function()
					require("gitsigns.actions").undo_stage_hunk()
				end)
					:with_buffer(bufnr)
					:with_desc("git: Undo stage hunk"),
				["n|<leader>hr"] = bind.map_callback(function()
					require("gitsigns.actions").reset_hunk()
				end)
					:with_buffer(bufnr)
					:with_desc("git: Reset hunk"),
				["v|<leader>hr"] = bind.map_callback(function()
					require("gitsigns.actions").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end)
					:with_buffer(bufnr)
					:with_desc("git: Reset hunk"),
				["n|<leader>hR"] = bind.map_callback(function()
					require("gitsigns.actions").reset_buffer()
				end)
					:with_buffer(bufnr)
					:with_desc("git: Reset buffer"),
				["n|<leader>hp"] = bind.map_callback(function()
					require("gitsigns.actions").preview_hunk()
				end)
					:with_buffer(bufnr)
					:with_desc("git: Preview hunk"),
				["n|<leader>hb"] = bind.map_callback(function()
					require("gitsigns.actions").blame_line({ full = true })
				end)
					:with_buffer(bufnr)
					:with_desc("git: Blame line"),
				-- Text objects
				["o|ih"] = bind.map_callback(function()
					require("gitsigns.actions").text_object()
				end):with_buffer(bufnr),
				["x|ih"] = bind.map_callback(function()
					require("gitsigns.actions").text_object()
				end):with_buffer(bufnr),
			})
		end,
		watch_gitdir = { interval = 1000, follow_files = true },
		current_line_blame = true,
		current_line_blame_opts = { delay = 1000, virtual_text_pos = "eol" },
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil, -- Use default
		word_diff = false,
		diff_opts = { internal = true },
	})
end
