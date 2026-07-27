return function()
	local icons = {
		diagnostics = require("modules.utils.icons").get("diagnostics"),
		ui = require("modules.utils.icons").get("ui"),
	}
	local settings = require("core.settings")

	require("modules.utils").load_plugin("snacks", {
		bigfile = {
			enabled = settings.load_big_files_faster,
			size = 2 * 1024 * 1024,
			line_length = 1000,
			setup = function(ctx)
				if vim.fn.exists(":NoMatchParen") ~= 0 then
					vim.cmd([[NoMatchParen]])
				end

				Snacks.util.wo(0, {
					conceallevel = 0,
					foldenable = false,
					foldmethod = "manual",
					list = false,
					statuscolumn = "",
				})
				Snacks.util.bo(ctx.buf, {
					swapfile = false,
					undofile = false,
					undolevels = -1,
				})

				vim.b[ctx.buf].completion = false
				vim.b[ctx.buf].minianimate_disable = true
				vim.b[ctx.buf].minihipatterns_disable = true
				vim.b[ctx.buf].snacks_indent = false
				vim.b[ctx.buf].snacks_scope = false
			end,
		},
		indent = {
			enabled = true,
			indent = {
				char = "│",
				priority = 2,
			},
			scope = {
				enabled = true,
				char = "┃",
				priority = 1000,
				underline = false,
			},
			animate = { enabled = false },
		},
		input = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 2000,
			width = { min = 50, max = 0.4 },
			level = vim.log.levels.INFO,
			icons = {
				error = icons.diagnostics.Error,
				warn = icons.diagnostics.Warning,
				info = icons.diagnostics.Information,
				debug = icons.ui.Bug,
				trace = icons.ui.Pencil,
			},
			style = "compact",
		},
		notify = { enabled = true },
		quickfile = { enabled = true },
		scroll = { enabled = false },
		picker = {
			enabled = true,
			prompt = icons.ui.Telescope .. " ",
			layout = {
				preset = function()
					return "nvimdots_bottom"
				end,
			},
			layouts = {
				nvimdots_bottom = {
					layout = {
						box = "vertical",
						backdrop = false,
						row = -1,
						width = 0,
						height = 0.45,
						border = "top",
						title = " {title} {live} {flags}",
						title_pos = "left",
						{
							box = "horizontal",
							{ win = "list", border = "none" },
							{ win = "preview", title = "{preview}", width = 0.55, border = "left" },
						},
						{ win = "input", height = 1, border = "bottom" },
					},
				},
				nvimdots_search = {
					layout = {
						box = "vertical",
						backdrop = false,
						row = -1,
						width = 0,
						height = 0.45,
						border = "top",
						{ win = "input", height = 1, border = "top" },
						{
							box = "horizontal",
							{ win = "list", border = "none" },
							{ win = "preview", title = "{preview}", width = 0.55, border = "left" },
						},
					},
				},
			},
			matcher = {
				smartcase = true,
			},
			sources = {
				files = {
					exclude = { ".git", ".cache", "build", "*.class", "*.pdf", "*.mkv", "*.mp4", "*.zip" },
				},
				grep = {
					exclude = { ".git", ".cache", "build", "*.class", "*.pdf", "*.mkv", "*.mp4", "*.zip" },
				},
			},
		},
	})
end
