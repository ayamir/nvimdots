return function()
	local icons = {
		diagnostics = require("modules.utils.icons").get("diagnostics", true),
		git = require("modules.utils.icons").get("git", true),
		ui = require("modules.utils.icons").get("ui", true),
	}
	local iconsNoSpace = { git = require("modules.utils.icons").get("git", false) }

	local mini_sections = {
		lualine_a = { "filetype" },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	}
	local outline = {
		sections = mini_sections,
		filetypes = { "lspsagaoutline" },
	}
	local diffview = {
		sections = mini_sections,
		filetypes = { "DiffviewFiles" },
	}

	local custom_theme = function()
		local cp = require("modules.utils").get_palette()
		return {
			normal = {
				a = { fg = cp.green, bg = cp.surface0, gui = "bold" },
				b = { fg = cp.text, bg = cp.mantle },
				c = { fg = cp.text, bg = cp.mantle },
			},
			command = { a = { fg = cp.yellow, bg = cp.surface0, gui = "bold" } },
			insert = { a = { fg = cp.blue, bg = cp.surface0, gui = "bold" } },
			visual = { a = { fg = cp.mauve, bg = cp.surface0, gui = "bold" } },
			terminal = { a = { fg = cp.teal, bg = cp.surface0, gui = "bold" } },
			replace = { a = { fg = cp.red, bg = cp.surface0, gui = "bold" } },
			inactive = {
				a = { fg = cp.subtext0, bg = cp.mantle, gui = "bold" },
				b = { fg = cp.subtext0, bg = cp.mantle },
				c = { fg = cp.subtext0, bg = cp.mantle },
			},
		}
	end
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("LualineColorScheme", { clear = true }),
		callback = function()
			require("lualine").setup({ options = { theme = custom_theme() } })
		end,
	})

	local conditions = {
		hide_in_width = function()
			return vim.o.columns > 100
		end,
		check_git_workspace = function()
			local filepath = vim.fn.expand("%:p:h")
			local gitdir = vim.fn.finddir(".git", filepath .. ";")
			return gitdir and #gitdir > 0 and #gitdir < #filepath
		end,
	}

	local function diff_source()
		local gitsigns = vim.b.gitsigns_status_dict
		if gitsigns then
			return {
				added = gitsigns.added,
				modified = gitsigns.changed,
				removed = gitsigns.removed,
			}
		end
	end

	local components = {
		separator = { -- use as section separators
			function()
				return "│"
			end,
			padding = {},
			color = "LualineSeparator",
		},

		lsp = {
			function()
				if rawget(vim, "lsp") then
					local names = {}
					local lsp_exist = false
					for _, client in ipairs(vim.lsp.get_active_clients()) do
						if client.attached_buffers[vim.api.nvim_get_current_buf()] and client.name ~= "null-ls" then
							table.insert(names, client.name)
							lsp_exist = true
						end
					end
					return lsp_exist and "󱜙 [" .. table.concat(names, ", ") .. "]" or "󱚧"
				end
				return "󱚧"
			end,
			color = "LualineLSP",
			cond = conditions.hide_in_width,
		},

		python_venv = {
			function()
				local function env_cleanup(venv)
					if string.find(venv, "/") then
						local final_venv = venv
						for w in venv:gmatch("([^/]+)") do
							final_venv = w
						end
						venv = final_venv
					end
					return venv
				end

				if vim.bo.filetype == "python" then
					local venv = os.getenv("CONDA_DEFAULT_ENV")
					if venv then
						return string.format("%s", env_cleanup(venv))
					end
					venv = os.getenv("VIRTUAL_ENV")
					if venv then
						return string.format("%s", env_cleanup(venv))
					end
				end
				return ""
			end,
			color = "LualinePyVenv",
			cond = conditions.hide_in_width,
		},
		cwd = {
			function()
				local cwd = vim.fn.getcwd()
				local is_windows = require("core.global").is_windows
				if not is_windows then
					local home = require("core.global").home
					if cwd:find(home, 1, true) == 1 then
						cwd = "~" .. cwd:sub(#home + 1)
					end
				end
				return icons.ui.RootFolderOpened .. cwd
			end,
			color = "LualineCWD",
		},
	}

	require("lualine").setup({
		options = {
			icons_enabled = true,
			theme = custom_theme(),
			disabled_filetypes = { statusline = { "alpha" } },
			component_separators = "",
			section_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = {
				-- idk what to put here

				-- FIXME: not perfect when in buffers such as `help`
				-- vim.tbl_deep_extend("force", components.separator, { cond = conditions.check_git_workspace }),
			},
			lualine_c = {
				{ -- branch
					"b:gitsigns_head",
					icon = iconsNoSpace.git.Branch,
					color = "LualineBranch",
				},
				{
					"diff",
					symbols = {
						added = icons.git.Add,
						modified = icons.git.Mod,
						removed = icons.git.Remove,
					},
					source = diff_source,
					colored = false,
					color = "LualineDiff",
					padding = { right = 1 },
				},

				{ -- center
					function()
						return "%="
					end,
				},

				{
					"diagnostics",
					sources = { "nvim_diagnostic" },
					sections = { "error", "warn", "info", "hint" },
					symbols = {
						error = icons.diagnostics.Error,
						warn = icons.diagnostics.Warning,
						info = icons.diagnostics.Information,
						hint = icons.diagnostics.Hint,
					},
				},
				components.lsp,
			},
			lualine_x = {
				{
					"o:encoding",
					fmt = string.upper,
					padding = { left = 1 },
					cond = conditions.hide_in_width,
				},
				{
					"fileformat",
					symbols = {
						unix = "LF",
						dos = "CRLF",
						mac = "CR",
					},
					padding = { left = 1 },
				},
				{ -- spaces
					function()
						local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
						return icons.ui.ChevronRight .. shiftwidth
					end,
					padding = 1,
				},
			},
			lualine_y = {
				components.separator,
				components.python_venv,
				components.cwd,
			},
			lualine_z = { "location" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		extensions = {
			"quickfix",
			"nvim-tree",
			"nvim-dap-ui",
			"toggleterm",
			"fugitive",
			outline,
			diffview,
		},
	})
end
