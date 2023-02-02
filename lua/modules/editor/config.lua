local config = {}
local sessions_dir = vim.fn.stdpath("data") .. "/sessions/"
local use_ssh = require("core.settings").use_ssh

function config.nvim_treesitter()
	vim.api.nvim_set_option_value("foldmethod", "expr", {})
	vim.api.nvim_set_option_value("foldexpr", "nvim_treesitter#foldexpr()", {})

	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"bash",
			"c",
			"cpp",
			"lua",
			"go",
			"gomod",
			"json",
			"yaml",
			"latex",
			"make",
			"markdown",
			"markdown_inline",
			"python",
			"rust",
			"html",
			"javascript",
			"typescript",
			"vue",
			"css",
		},
		highlight = {
			enable = true,
			disable = function(ft, bufnr)
				if vim.tbl_contains({ "vim" }, ft) then
					return true
				end

				local ok, is_large_file = pcall(vim.api.nvim_buf_get_var, bufnr, "bigfile_disable_treesitter")
				return ok and is_large_file
			end,
			additional_vim_regex_highlighting = { "c", "cpp" },
		},
		textobjects = {
			select = {
				enable = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]["] = "@function.outer",
					["]m"] = "@class.outer",
				},
				goto_next_end = {
					["]]"] = "@function.outer",
					["]M"] = "@class.outer",
				},
				goto_previous_start = {
					["[["] = "@function.outer",
					["[m"] = "@class.outer",
				},
				goto_previous_end = {
					["[]"] = "@function.outer",
					["[M"] = "@class.outer",
				},
			},
		},
		rainbow = {
			enable = true,
			extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
			max_file_lines = 2000, -- Do not enable for files with more than 2000 lines, int
		},
		context_commentstring = { enable = true, enable_autocmd = false },
		matchup = { enable = true },
	})
	require("nvim-treesitter.install").prefer_git = true
	if use_ssh then
		local parsers = require("nvim-treesitter.parsers").get_parser_configs()
		for _, p in pairs(parsers) do
			p.install_info.url = p.install_info.url:gsub("https://github.com/", "git@github.com:")
		end
	end
end

function config.illuminate()
	require("illuminate").configure({
		providers = {
			"lsp",
			"treesitter",
			"regex",
		},
		delay = 100,
		filetypes_denylist = {
			"alpha",
			"dashboard",
			"DoomInfo",
			"fugitive",
			"help",
			"norg",
			"NvimTree",
			"Outline",
			"toggleterm",
		},
		under_cursor = false,
	})
end

function config.nvim_comment()
	require("nvim_comment").setup({
		hook = function()
			require("ts_context_commentstring.internal").update_commentstring()
		end,
	})
end

function config.hop()
	require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
end

function config.autotag()
	require("nvim-ts-autotag").setup({
		filetypes = {
			"html",
			"xml",
			"javascript",
			"typescriptreact",
			"javascriptreact",
			"vue",
		},
	})
end

function config.nvim_colorizer()
	require("colorizer").setup()
end

function config.neoscroll()
	require("neoscroll").setup({
		-- All these keys will be mapped to their corresponding default scrolling animation
		mappings = {
			"<C-u>",
			"<C-d>",
			"<C-b>",
			"<C-f>",
			"<C-y>",
			"<C-e>",
			"zt",
			"zz",
			"zb",
		},
		hide_cursor = true, -- Hide cursor while scrolling
		stop_eof = true, -- Stop at <EOF> when scrolling downwards
		use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
		respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
		cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
		easing_function = nil, -- Default easing function
		pre_hook = nil, -- Function to run before the scrolling animation starts
		post_hook = nil, -- Function to run after the scrolling animation ends
	})
end

function config.auto_session()
	local opts = {
		log_level = "info",
		auto_session_enable_last_session = true,
		auto_session_root_dir = sessions_dir,
		auto_session_enabled = true,
		auto_save_enabled = true,
		auto_restore_enabled = true,
		auto_session_suppress_dirs = nil,
	}

	require("auto-session").setup(opts)
end

function config.toggleterm()
	local colors = require("modules.utils").get_palette()
	local floatborder_hl = require("modules.utils").hl_to_rgb("FloatBorder", false, colors.blue)

	require("toggleterm").setup({
		-- size can be a number or function which is passed the current terminal
		size = function(term)
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.40
			end
		end,
		highlights = {
			FloatBorder = {
				guifg = floatborder_hl,
			},
		},
		on_open = function()
			-- Prevent infinite calls from freezing neovim.
			-- Only set these options specific to this terminal buffer.
			vim.api.nvim_set_option_value("foldmethod", "manual", { scope = "local" })
			vim.api.nvim_set_option_value("foldexpr", "0", { scope = "local" })
		end,
		open_mapping = false, -- [[<c-\>]],
		hide_numbers = true, -- hide the number column in toggleterm buffers
		shade_filetypes = {},
		shade_terminals = false,
		shading_factor = "1", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
		start_in_insert = true,
		insert_mappings = true, -- whether or not the open mapping applies in insert mode
		persist_size = true,
		direction = "horizontal",
		close_on_exit = true, -- close the terminal window when the process exits
		shell = vim.o.shell, -- change the default shell
	})
end

function config.dapui()
	local icons = {
		ui = require("modules.ui.icons").get("ui"),
		dap = require("modules.ui.icons").get("dap"),
	}

	require("dapui").setup({
		icons = { expanded = icons.ui.ArrowOpen, collapsed = icons.ui.ArrowClosed, current_frame = icons.ui.Indicator },
		mappings = {
			-- Use a table to apply multiple mappings
			expand = { "<CR>", "<2-LeftMouse>" },
			open = "o",
			remove = "d",
			edit = "e",
			repl = "r",
		},
		layouts = {
			{
				elements = {
					-- Provide as ID strings or tables with "id" and "size" keys
					{
						id = "scopes",
						size = 0.25, -- Can be float or integer > 1
					},
					{ id = "breakpoints", size = 0.25 },
					{ id = "stacks", size = 0.25 },
					{ id = "watches", size = 0.25 },
				},
				size = 40,
				position = "left",
			},
			{ elements = { "repl" }, size = 10, position = "bottom" },
		},
		-- Requires Nvim version >= 0.8
		controls = {
			enabled = true,
			-- Display controls in this session
			element = "repl",
			icons = {
				pause = icons.dap.Pause,
				play = icons.dap.Play,
				step_into = icons.dap.StepInto,
				step_over = icons.dap.StepOver,
				step_out = icons.dap.StepOut,
				step_back = icons.dap.StepBack,
				run_last = icons.dap.RunLast,
				terminate = icons.dap.Terminate,
			},
		},
		floating = {
			max_height = nil,
			max_width = nil,
			mappings = { close = { "q", "<Esc>" } },
		},
		windows = { indent = 1 },
	})
end

function config.dap()
	local icons = { dap = require("modules.ui.icons").get("dap") }
	local colors = require("modules.utils").get_palette()

	local dap = require("dap")
	local dapui = require("dapui")

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.after.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.after.event_exited["dapui_config"] = function()
		dapui.close()
	end

	-- We need to override nvim-dap's default highlight groups, AFTER requiring nvim-dap for catppuccin.
	vim.api.nvim_set_hl(0, "DapStopped", { fg = colors.green })

	vim.fn.sign_define(
		"DapBreakpoint",
		{ text = icons.dap.Breakpoint, texthl = "DapBreakpoint", linehl = "", numhl = "" }
	)
	vim.fn.sign_define(
		"DapBreakpointCondition",
		{ text = icons.dap.BreakpointCondition, texthl = "DapBreakpoint", linehl = "", numhl = "" }
	)
	vim.fn.sign_define("DapStopped", { text = icons.dap.Stopped, texthl = "DapStopped", linehl = "", numhl = "" })
	vim.fn.sign_define(
		"DapBreakpointRejected",
		{ text = icons.dap.BreakpointRejected, texthl = "DapBreakpoint", linehl = "", numhl = "" }
	)
	vim.fn.sign_define("DapLogPoint", { text = icons.dap.LogPoint, texthl = "DapLogPoint", linehl = "", numhl = "" })

	dap.adapters.lldb = {
		type = "executable",
		command = "/usr/bin/lldb-vscode",
		name = "lldb",
	}
	dap.configurations.cpp = {
		{
			name = "Launch",
			type = "lldb",
			request = "launch",
			args = function()
				local input = vim.fn.input("Input args: ")
				return vim.fn.split(input, " ", true)
			end,
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,

			-- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
			--
			--    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
			--
			-- Otherwise you might get the following error:
			--
			--    Error on launch: Failed to attach to the target process
			--
			-- But you should be aware of the implications:
			-- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
			runInTerminal = false,
		},
	}

	dap.configurations.c = dap.configurations.cpp
	dap.configurations.rust = dap.configurations.cpp

	dap.adapters.go = function(callback)
		local stdout = vim.loop.new_pipe(false)
		local handle
		local pid_or_err
		local port = 38697
		local opts = {
			stdio = { nil, stdout },
			args = { "dap", "-l", "127.0.0.1:" .. port },
			detached = true,
		}
		handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
			stdout:close()
			handle:close()
			if code ~= 0 then
				vim.notify(
					string.format('"dlv" exited with code: %d, please check your configs for correctness.', code),
					vim.log.levels.WARN,
					{ title = "[go] DAP Warning!" }
				)
			end
		end)
		assert(handle, "Error running dlv: " .. tostring(pid_or_err))
		stdout:read_start(function(err, chunk)
			assert(not err, err)
			if chunk then
				vim.schedule(function()
					require("dap.repl").append(chunk)
				end)
			end
		end)
		-- Wait for delve to start
		vim.defer_fn(function()
			callback({ type = "server", host = "127.0.0.1", port = port })
		end, 100)
	end
	-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
	dap.configurations.go = {
		{ type = "go", name = "Debug", request = "launch", program = "${file}" },
		{
			type = "go",
			name = "Debug test", -- configuration for debugging test files
			request = "launch",
			mode = "test",
			program = "${file}",
		}, -- works with go.mod packages and sub packages
		{
			type = "go",
			name = "Debug test (go.mod)",
			request = "launch",
			mode = "test",
			program = "./${relativeFileDirname}",
		},
	}

	dap.adapters.python = {
		type = "executable",
		command = "/usr/bin/python",
		args = { "-m", "debugpy.adapter" },
	}
	dap.configurations.python = {
		{
			-- The first three options are required by nvim-dap
			type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
			request = "launch",
			name = "Launch file",
			-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

			program = "${file}", -- This configuration will launch the current file if used.
			pythonPath = function()
				-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
				-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
				-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
				local cwd = vim.fn.getcwd()
				if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
					return cwd .. "/venv/bin/python"
				elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
					return cwd .. "/.venv/bin/python"
				else
					return "/usr/bin/python"
				end
			end,
		},
	}
end

function config.specs()
	require("specs").setup({
		show_jumps = true,
		min_jump = 10,
		popup = {
			delay_ms = 0, -- delay before popup displays
			inc_ms = 10, -- time increments used for fade/resize effects
			blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
			width = 10,
			winhl = "PMenu",
			fader = require("specs").pulse_fader,
			resizer = require("specs").shrink_resizer,
		},
		ignore_filetypes = {},
		ignore_buftypes = { nofile = true },
	})
end

function config.imselect()
	-- fcitx5 need a manual config
	if vim.fn.executable("fcitx5-remote") == 1 then
		vim.api.nvim_cmd({
			[[ let g:im_select_get_im_cmd = ["fcitx5-remote"] ]],
			[[ let g:im_select_default = '1' ]],
			[[ let g:ImSelectSetImCmd = {
			\ key ->
			\ key == 1 ? ['fcitx5-remote', '-c'] :
			\ key == 2 ? ['fcitx5-remote', '-o'] :
			\ key == 0 ? ['fcitx5-remote', '-c'] :
			\ execute("throw 'invalid im key'")
			\ }
			]],
		}, { true, true, true })
	end
end

function config.better_escape()
	require("better_escape").setup({
		mapping = { "jk", "jj" }, -- a table with mappings to use
		timeout = 500, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
		clear_empty_lines = false, -- clear line after escaping if there is only whitespace
		keys = "<Esc>", -- keys used for escaping, if it is a function will use the result everytime
		-- example(recommended)
		-- keys = function()
		--   return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>'
		-- end,
	})
end

function config.accelerated_jk()
	require("accelerated-jk").setup({
		mode = "time_driven",
		enable_deceleration = false,
		acceleration_motions = {},
		acceleration_limit = 150,
		acceleration_table = { 7, 12, 17, 21, 24, 26, 28, 30 },
		-- when 'enable_deceleration = true', 'deceleration_table = { {200, 3}, {300, 7}, {450, 11}, {600, 15}, {750, 21}, {900, 9999} }'
		deceleration_table = { { 150, 9999 } },
	})
end

function config.clever_f()
	vim.api.nvim_set_hl(
		0,
		"CleverChar",
		{ underline = true, bold = true, fg = "Orange", bg = "NONE", ctermfg = "Red", ctermbg = "NONE" }
	)
	vim.g.clever_f_mark_char_color = "CleverChar"
	vim.g.clever_f_mark_direct_color = "CleverChar"
	vim.g.clever_f_mark_direct = true
	vim.g.clever_f_timeout_ms = 1500
end

function config.smartyank()
	require("smartyank").setup({
		highlight = {
			enabled = false, -- highlight yanked text
			higroup = "IncSearch", -- highlight group of yanked text
			timeout = 2000, -- timeout for clearing the highlight
		},
		clipboard = {
			enabled = true,
		},
		tmux = {
			enabled = true,
			-- remove `-w` to disable copy to host client's clipboard
			cmd = { "tmux", "set-buffer", "-w" },
		},
		osc52 = {
			enabled = true,
			escseq = "tmux", -- use tmux escape sequence, only enable if you're using remote tmux and have issues (see #4)
			ssh_only = true, -- false to OSC52 yank also in local sessions
			silent = false, -- true to disable the "n chars copied" echo
			echo_hl = "Directory", -- highlight group of the OSC52 echo message
		},
	})
end

function config.tabout()
	require("tabout").setup({
		tabkey = "", -- key to trigger tabout, set to an empty string to disable
		backwards_tabkey = "", -- key to trigger backwards tabout, set to an empty string to disable
		act_as_tab = true, -- shift content if tab out is not possible
		act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
		enable_backwards = true,
		completion = true, -- if the tabkey is used in a completion pum
		tabouts = {
			{ open = "'", close = "'" },
			{ open = '"', close = '"' },
			{ open = "`", close = "`" },
			{ open = "(", close = ")" },
			{ open = "[", close = "]" },
			{ open = "{", close = "}" },
		},
		ignore_beginning = true, -- if the cursor is at the beginning of a filled element it will rather tab out than shift the content
		exclude = {}, -- tabout will ignore these filetypes
	})
end

function config.bigfile()
	local ftdetect = {
		name = "ftdetect",
		opts = { defer = true },
		disable = function()
			vim.api.nvim_set_option_value("filetype", "big_file_disabled_ft", { scope = "local" })
		end,
	}

	local cmp = {
		name = "nvim-cmp",
		opts = { defer = true },
		disable = function()
			require("cmp").setup.buffer({ enabled = false })
		end,
	}

	require("bigfile").config({
		filesize = 1, -- size of the file in MiB
		pattern = { "*" }, -- autocmd pattern
		features = { -- features to disable
			"indent_blankline",
			"lsp",
			"illuminate",
			"treesitter",
			"syntax",
			"vimopts",
			ftdetect,
			cmp,
		},
	})
end

return config
