return function()
	require("legendary").setup({
		which_key = {
			auto_register = true,
			do_binding = false,
		},
		scratchpad = {
			view = "float",
			results_view = "float",
			keep_contents = true,
		},
		sort = {
			-- sort most recently used item to the top
			most_recent_first = true,
			-- sort user-defined items before built-in items
			user_items_first = true,
			frecency = {
				-- the directory to store the database in
				db_root = string.format("%s/legendary/", vim.fn.stdpath("data")),
				-- the maximum number of timestamps for a single item
				-- to store in the database
				max_timestamps = 10,
			},
		},
		-- Directory used for caches
		cache_path = string.format("%s/legendary/", vim.fn.stdpath("cache")),
		-- Log level, one of 'trace', 'debug', 'info', 'warn', 'error', 'fatal'
		log_level = "info",
	})

	require("which-key").register({
		["<leader>"] = {
			b = {
				name = "Bufferline commands",
				d = "buffer: Sort by directory",
				e = "buffer: Sort by extension",
			},
			d = {
				name = "Dap commands",
				b = "debug: Set breakpoint with condition",
				c = "debug: Run to cursor",
				l = "debug: Run last",
				o = "debug: Open repl",
			},
			f = {
				name = "Telescope commands",
				p = "find: Project",
				w = "find: Word",
				r = "find: File by frecency",
				e = "find: File by history",
				c = "ui: Change color scheme",
				z = "edit: Change current directory by zoxide",
				f = "find: File under current work directory",
				g = "find: File under current git directory",
				n = "edit: New file",
				b = "find: Buffer opened",
			},
			h = {
				name = "Gitsigns commands",
			},
			l = {
				name = "LSP commands",
				i = "lsp: LSP Info",
				r = "lsp: LSP Restart",
			},
			n = {
				name = "NvimTree commands",
				f = "filetree: NvimTree find file",
				r = "filetree: NvimTree refresh",
			},
			p = {
				name = "Package commands",
				h = "package: Show",
				s = "package: Sync",
				i = "package: Install",
				c = "package: Check",
				d = "package: Debug",
				l = "package: Log",
				p = "package: Profile",
				r = "package: Restore",
				x = "package: Clean",
				u = "package: Update",
			},
			s = {
				c = "lsp: Show cursor disgnostics",
				l = "lsp: Show line disgnostics",
				s = "sesson: Save session",
				r = "sesson: Restore session",
				d = "sesson: Delete session",
			},
			t = {
				name = "Trouble commands",
				d = "lsp: Show document diagnostics",
				w = "lsp: Show workspace diagnostics",
				q = "lsp: Show quickfix list",
				l = "lsp: Show loclist",
				r = "lsp: Show lsp references",
			},
		},
		["g"] = {
			a = "lsp: Code action",
			d = "lsp: Preview definition",
			D = "lsp: Goto definition",
			h = "lsp: Show reference",
			o = "lsp: Toggle outline",
			r = "lsp: Rename in file range",
			R = "lsp: Rename in project range",
			s = "lsp: Signature help",
			t = "lsp: Toggle trouble list",
			b = "buffer: Buffer pick",
			p = {
				name = "git commands",
				s = "git: Push",
				l = "git: Pull",
			},
		},
		["<F6>"] = "debug: Run/Continue",
		["<F7>"] = "debug: Terminate debug session",
		["<F8>"] = "debug: Toggle breakpoint",
		["<F9>"] = "debug: Step into",
		["<F10>"] = "debug: Step out",
		["<F11>"] = "debug: Step over",
		["<leader>G"] = "git: Show fugitive",
		["<leader>g"] = "git: Show lazygit",
		["<leader>D"] = "git: Show diff",
		["<leader><leader>D"] = "git: Close diff",
		["g["] = "lsp: Goto prev diagnostic",
		["g]"] = "lsp: Goto next diagnostic",
		["<leader>ci"] = "lsp: Incoming calls",
		["<leader>co"] = "lsp: Outgoing calls",
		["<leader>w"] = "jump: Goto word",
		["<leader>j"] = "jump: Goto line",
		["<leader>k"] = "jump: Goto line",
		["<leader>c"] = "jump: Goto one char",
		["<leader>cc"] = "jump: Goto two chars",
		["<leader>o"] = "edit: Check spell",
		["<leader>u"] = "edit: Show undo history",
		["<leader>r"] = "tool: Code snip run",
		["<F12>"] = "tool: Markdown preview",
	})
end
