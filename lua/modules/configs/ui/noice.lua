return function()
	require("modules.utils").load_plugin("noice", {
		cmdline = {
			enabled = true, -- enables the noice cmdline ui
			view = "cmdline_popup", -- view for rendering the cmdline. change to `cmdline` to get a classic cmdline at the bottom
			opts = {}, -- global options for the cmdline. see section on views
			format = {
				-- conceal: (default=true) this will hide the text in the cmdline that matches the pattern.
				-- view: (default is cmdline view)
				-- opts: any options passed to the view
				-- icon_hl_group: optional hl_group for the icon
				-- title: set to anything or empty string to hide
				cmdline = { pattern = "^:", icon = "", lang = "vim" },
				search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
				search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
				filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
				lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
				help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋗" },
				input = {}, -- used by input()
				-- lua = false, -- to disable a format, set to `false`
			},
		},
		messages = {
			enabled = false, -- enables the noice messages ui
		},
		lsp = {
			progress = {
				enabled = false,
			},
			-- override markdown rendering so that **cmp** and other plugins use **treesitter**
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			hover = {
				enabled = false,
			},
			signature = {
				enabled = false,
			},
			message = {
				enabled = false,
			},
		},
		-- you can enable a preset for easier configuration
		presets = {
			bottom_search = true, -- use a classic bottom cmdline for search
			command_palette = true, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = false, -- add a border to hover docs and signature help
		},
		views = {
			cmdline_popup = {
				position = {
					row = "70%",
					col = "50%",
				},
				size = {
					width = "auto",
					height = "auto",
				},
			},
		},
	})
end
