local config = {}

function config.rust_tools()
	local opts = {
		tools = { -- rust-tools options

			-- how to execute terminal commands
			-- options right now: termopen / quickfix
			executor = require("rust-tools/executors").termopen,

			-- callback to execute once rust-analyzer is done initializing the workspace
			-- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
			on_initialized = function()
				require("lsp_signature").on_attach({
					bind = true,
					use_lspsaga = false,
					floating_window = true,
					fix_pos = true,
					hint_enable = true,
					hi_parameter = "Search",
					handler_opts = {
						border = "rounded",
					},
				})
			end,

			-- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
			reload_workspace_from_cargo_toml = true,

			-- These apply to the default RustSetInlayHints command
			inlay_hints = {
				-- automatically set inlay hints (type hints)
				-- default: true
				auto = true,

				-- Only show inlay hints for the current line
				only_current_line = false,

				-- whether to show parameter hints with the inlay hints or not
				-- default: true
				show_parameter_hints = true,

				-- prefix for parameter hints
				-- default: "<-"
				parameter_hints_prefix = "<- ",

				-- prefix for all the other hints (type, chaining)
				-- default: "=>"
				other_hints_prefix = "=> ",

				-- whether to align to the lenght of the longest line in the file
				max_len_align = false,

				-- padding from the left if max_len_align is true
				max_len_align_padding = 1,

				-- whether to align to the extreme right or not
				right_align = false,

				-- padding from the right if right_align is true
				right_align_padding = 7,

				-- The color of the hints
				highlight = "Comment",
			},

			-- options same as lsp hover / vim.lsp.util.open_floating_preview()
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
				-- default: false
				auto_focus = false,
			},

			-- settings for showing the crate graph based on graphviz and the dot
			-- command
			crate_graph = {
				-- Backend used for displaying the graph
				-- see: https://graphviz.org/docs/outputs/
				-- default: x11
				backend = "x11",
				-- where to store the output, nil for no output stored (relative
				-- path from pwd)
				-- default: nil
				output = nil,
				-- true for all crates.io and external crates, false only the local
				-- crates
				-- default: true
				full = true,

				-- List of backends found on: https://graphviz.org/docs/outputs/
				-- Is used for input validation and autocompletion
				-- Last updated: 2021-08-26
				enabled_graphviz_backends = {
					"bmp",
					"cgimage",
					"canon",
					"dot",
					"gv",
					"xdot",
					"xdot1.2",
					"xdot1.4",
					"eps",
					"exr",
					"fig",
					"gd",
					"gd2",
					"gif",
					"gtk",
					"ico",
					"cmap",
					"ismap",
					"imap",
					"cmapx",
					"imap_np",
					"cmapx_np",
					"jpg",
					"jpeg",
					"jpe",
					"jp2",
					"json",
					"json0",
					"dot_json",
					"xdot_json",
					"pdf",
					"pic",
					"pct",
					"pict",
					"plain",
					"plain-ext",
					"png",
					"pov",
					"ps",
					"ps2",
					"psd",
					"sgi",
					"svg",
					"svgz",
					"tga",
					"tiff",
					"tif",
					"tk",
					"vml",
					"vmlz",
					"wbmp",
					"webp",
					"xlib",
					"x11",
				},
			},
		},

		-- all the opts to send to nvim-lspconfig
		-- these override the defaults set by rust-tools.nvim
		-- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
		server = {
			-- standalone file support
			-- setting it to false may improve startup time
			standalone = true,
		}, -- rust-analyer options

		-- debugging stuff
		dap = {
			adapter = {
				type = "executable",
				command = "lldb-vscode",
				name = "rt_lldb",
			},
		},
	}

	require("rust-tools").setup(opts)
end

function config.crates()
	local icons = {
		diagnostics = require("modules.ui.icons").get("diagnostics", true),
		git = require("modules.ui.icons").get("git", true),
		misc = require("modules.ui.icons").get("misc", true),
		ui = require("modules.ui.icons").get("ui", true),
		kind = require("modules.ui.icons").get("kind", true),
	}

	local opts = {
		smart_insert = true,
		insert_closing_quote = true,
		avoid_prerelease = true,
		autoload = true,
		autoupdate = true,
		autoupdate_throttle = 250,
		loading_indicator = true,
		date_format = "%Y-%m-%d",
		thousands_separator = ",",
		notification_title = "Crates",
		curl_args = { "-sL", "--retry", "1" },
		disable_invalid_feature_diagnostic = false,
		text = {
			loading = " " .. icons.misc.Watch .. "Loading",
			version = " " .. icons.ui.Check .. "%s",
			prerelease = " " .. icons.diagnostics.Warning_alt .. "%s",
			yanked = " " .. icons.diagnostics.Error .. "%s",
			nomatch = " " .. icons.diagnostics.Question .. "No match",
			upgrade = " " .. icons.diagnostics.Hint_alt .. "%s",
			error = " " .. icons.diagnostics.Error .. "Error fetching crate",
		},
		popup = {
			autofocus = false,
			hide_on_select = true,
			copy_register = '"',
			style = "minimal",
			border = "rounded",
			show_version_date = true,
			show_dependency_version = true,
			max_height = 30,
			min_width = 20,
			padding = 1,
			text = {
				title = icons.ui.Package .. "%s",
				description = "%s",
				created_label = icons.misc.Added .. "created" .. "        ",
				created = "%s",
				updated_label = icons.misc.ManUp .. "updated" .. "        ",
				updated = "%s",
				downloads_label = icons.ui.CloudDownload .. "downloads      ",
				downloads = "%s",
				homepage_label = icons.misc.Campass .. "homepage       ",
				homepage = "%s",
				repository_label = icons.git.Repo .. "repository     ",
				repository = "%s",
				documentation_label = icons.diagnostics.Information_alt .. "documentation  ",
				documentation = "%s",
				crates_io_label = icons.ui.Package .. "crates.io      ",
				crates_io = "%s",
				categories_label = icons.kind.Class .. "categories     ",
				keywords_label = icons.kind.Keyword .. "keywords       ",
				version = "  %s",
				prerelease = icons.diagnostics.Warning_alt .. "%s prerelease",
				yanked = icons.diagnostics.Error .. "%s yanked",
				version_date = "  %s",
				feature = "  %s",
				enabled = icons.ui.Play .. "%s",
				transitive = icons.ui.List .. "%s",
				normal_dependencies_title = icons.kind.Interface .. "Dependencies",
				build_dependencies_title = icons.misc.Gavel .. "Build dependencies",
				dev_dependencies_title = icons.misc.Glass .. "Dev dependencies",
				dependency = "  %s",
				optional = icons.ui.BigUnfilledCircle .. "%s",
				dependency_version = "  %s",
				loading = " " .. icons.misc.Watch,
			},
		},
		src = {
			insert_closing_quote = true,
			text = {
				prerelease = " " .. icons.diagnostics.Warning_alt .. "pre-release ",
				yanked = " " .. icons.diagnostics.Error_alt .. "yanked ",
			},
		},
	}

	require("crates").setup(opts)
end

function config.lang_go()
	vim.g.go_doc_keywordprg_enabled = 0
	vim.g.go_def_mapping_enabled = 0
	vim.g.go_code_completion_enabled = 0
end

-- function config.lang_org()
--     require("orgmode").setup({
--         org_agenda_files = {"~/Sync/org/*"},
--         org_default_notes_file = "~/Sync/org/refile.org"
--     })
-- end

return config
