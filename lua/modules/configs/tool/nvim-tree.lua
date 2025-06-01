return function()
	local icons = {
		diagnostics = require("modules.utils.icons").get("diagnostics"),
		documents = require("modules.utils.icons").get("documents"),
		git = require("modules.utils.icons").get("git"),
		ui = require("modules.utils.icons").get("ui"),
	}

	require("modules.utils").load_plugin("nvim-tree", {
		auto_reload_on_write = true,
		disable_netrw = false,
		hijack_cursor = true,
		hijack_netrw = false,
		hijack_unnamed_buffer_when_opening = true,
		respect_buf_cwd = true,
		prefer_startup_root = false,
		sync_root_with_cwd = true,
		renderer = {
			full_name = false,
			group_empty = true,
			add_trailing = false,
			symlink_destination = true,
			highlight_git = "all",
			root_folder_label = ":.:s?.*?/..?",
			special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "CMakeLists.txt" },
			indent_markers = {
				enable = true,
				inline_arrows = true,
			},
			icons = {
				show = {
					file = true,
					folder = true,
					folder_arrow = true,
					git = true,
				},
				padding = " ",
				symlink_arrow = " 󰁔 ",
				git_placement = "after",
				glyphs = {
					default = icons.documents.Default,
					symlink = icons.documents.Symlink,
					bookmark = icons.ui.Bookmark,
					git = {
						unstaged = icons.git.Mod_alt,
						staged = icons.git.Add,
						unmerged = icons.git.Unmerged,
						renamed = icons.git.Rename,
						untracked = icons.git.Untracked,
						deleted = icons.git.Remove,
						ignored = icons.git.Ignore,
					},
					folder = {
						arrow_open = icons.ui.ArrowOpen,
						arrow_closed = icons.ui.ArrowClosed,
						default = icons.ui.Folder,
						open = icons.ui.FolderOpen,
						empty = icons.ui.EmptyFolder,
						empty_open = icons.ui.EmptyFolderOpen,
						symlink = icons.ui.SymlinkFolder,
						symlink_open = icons.ui.FolderOpen,
					},
				},
			},
		},
		actions = {
			use_system_clipboard = true,
			change_dir = {
				enable = true,
				global = false,
			},
			open_file = {
				quit_on_open = false,
				resize_window = true,
				window_picker = {
					enable = true,
					chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
					exclude = {
						buftype = {
							"help",
							"nofile",
							"prompt",
							"quickfix",
							"terminal",
						},
						filetype = {
							"dap-repl",
							"diff",
							"fugitive",
							"fugitiveblame",
							"git",
							"notify",
							"Outline",
							"qf",
							"TelescopePrompt",
							"toggleterm",
							"undotree",
						},
					},
				},
			},
			remove_file = {
				close_window = true,
			},
		},
		diagnostics = {
			enable = false,
			show_on_dirs = false,
			debounce_delay = 50,
			icons = {
				hint = icons.diagnostics.Hint_alt,
				info = icons.diagnostics.Information_alt,
				warning = icons.diagnostics.Warning_alt,
				error = icons.diagnostics.Error_alt,
			},
		},
		filters = {
			enable = true,
			dotfiles = false,
			no_buffer = false,
			git_clean = false,
			git_ignored = true,
			no_bookmark = false,
			custom = { ".DS_Store" },
		},
		update_focused_file = {
			enable = true,
			update_root = { enable = true },
		},
		trash = {
			cmd = "gio trash",
		},
		log = {
			enable = false,
		},
	})
end
