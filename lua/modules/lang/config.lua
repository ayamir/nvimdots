local config = {}

function config.rust_tools()
	vim.cmd([[packadd nvim-lspconfig]])
	local opts = {
		tools = {
			-- rust-tools options
			-- Automatically set inlay hints (type hints)
			autoSetHints = true,
			-- Whether to show hover actions inside the hover window
			-- This overrides the default hover handler
			hover_with_actions = true,
			runnables = {
				-- whether to use telescope for selection menu or not
				use_telescope = true,

				-- rest of the opts are forwarded to telescope
			},
			debuggables = {
				-- whether to use telescope for selection menu or not
				use_telescope = true,

				-- rest of the opts are forwarded to telescope
			},
			-- These apply to the default RustSetInlayHints command
			inlay_hints = {
				-- Only show inlay hints for the current line
				only_current_line = false,
				-- Event which triggers a refersh of the inlay hints.
				-- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
				-- not that this may cause  higher CPU usage.
				-- This option is only respected when only_current_line and
				-- autoSetHints both are true.
				only_current_line_autocmd = "CursorHold",
				-- wheter to show parameter hints with the inlay hints or not
				show_parameter_hints = true,
				-- prefix for parameter hints
				parameter_hints_prefix = "<- ",
				-- prefix for all the other hints (type, chaining)
				other_hints_prefix = " » ",
				-- whether to align to the length of the longest line in the file
				max_len_align = false,
				-- padding from the left if max_len_align is true
				max_len_align_padding = 1,
				-- whether to align to the extreme right or not
				right_align = false,
				-- padding from the right if right_align is true
				right_align_padding = 7,
			},
			hover_actions = {
				-- the border that is used for the hover window
				-- see vim.api.nvim_open_win()
				border = {
					{ "╭", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╮", "FloatBorder" },
					{ "│", "FloatBorder" },
					{ "╯", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╰", "FloatBorder" },
					{ "│", "FloatBorder" },
				},
				-- whether the hover action window gets automatically focused
				auto_focus = false,
			},
		},
		-- all the opts to send to nvim-lspconfig
		-- these override the defaults set by rust-tools.nvim
		-- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
		server = {}, -- rust-analyer options
	}

	require("rust-tools").setup(opts)
end

function config.lang_go()
	vim.g.go_doc_keywordprg_enabled = false
	vim.g.go_def_mapping_enabled = false
end

-- function config.lang_org()
--     require("orgmode").setup({
--         org_agenda_files = {"~/Sync/org/*"},
--         org_default_notes_file = "~/Sync/org/refile.org"
--     })
-- end

return config
