return function()
	require("modules.utils").load_plugin("Comment", {
		-- Add a space b/w comment and the line
		padding = true,
		-- Whether the cursor should stay at its position
		sticky = true,
		-- Lines to be ignored while (un)comment
		ignore = "^$",
		-- LHS of toggle mappings in NORMAL mode
		toggler = {
			-- Line-comment toggle keymap
			line = "gcc",
			-- Block-comment toggle keymap
			block = "gbc",
		},
		-- LHS of operator-pending mappings in NORMAL and VISUAL mode
		opleader = {
			-- Line-comment keymap
			line = "gc",
			-- Block-comment keymap
			block = "gb",
		},
		-- LHS of extra mappings
		extra = {
			-- Add comment on the line above
			above = "gcO",
			-- Add comment on the line below
			below = "gco",
			-- Add comment at the end of line
			eol = "gcA",
		},
		-- We defined mappings in `lua/keymap/init.lua` with description so disable them here.
		mappings = {
			-- Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
			basic = false,
			-- Extra mapping; `gco`, `gcO`, `gcA`
			extra = false,
		},
		-- Function to call before (un)comment
		pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		-- Function to call after (un)comment
		post_hook = nil,
	})
end
