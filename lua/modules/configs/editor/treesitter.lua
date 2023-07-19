return vim.schedule_wrap(function()
	local use_ssh = require("core.settings").use_ssh
	local function table_contains(tbl, x)
		local found = false
		for _, v in pairs(tbl) do
			if v == x then
				found = true
			end
		end
		return found
	end

	vim.api.nvim_set_option_value("foldmethod", "expr", {})
	vim.api.nvim_set_option_value("foldexpr", "nvim_treesitter#foldexpr()", {})

	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"bash",
			"c",
			"cpp",
			"css",
			"go",
			"gomod",
			"html",
			"javascript",
			"json",
			"latex",
			"lua",
			"make",
			"markdown",
			"markdown_inline",
			"python",
			"rust",
			"typescript",
			"vimdoc",
			"vue",
			"yaml",
		},
		highlight = {
			enable = true,
			disable = function(_, bufnr)
				local buf_name = vim.api.nvim_buf_get_name(bufnr)
				-- local filetype = vim.bo.filetype
				local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
				local disable_type = { "org", "tex", "latex" }
				if table_contains(disable_type, filetype) then
					return true
				end
				local file_size = vim.api.nvim_call_function("getfsize", { buf_name })
				return file_size > 50 * 1024
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
		endwise = {
			enable = true,
			disable = function(_, bufnr)
				local disable_type = {}
				local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
				if table_contains(disable_type, filetype) then
					return true
				end
				local buf_name = vim.api.nvim_buf_get_name(bufnr)
				local file_size = vim.api.nvim_call_function("getfsize", { buf_name })
				return file_size > 256 * 1024
			end,
		},
		autotag = {
			enable = true,
			disable = function(_, bufnr)
				local disable_type = {}
				local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
				if table_contains(disable_type, filetype) then
					return true
				end
				local buf_name = vim.api.nvim_buf_get_name(bufnr)
				local file_size = vim.api.nvim_call_function("getfsize", { buf_name })
				return file_size > 256 * 1024
			end,
		},
		playground = {
			enable = true,
			disable = function(_, bufnr)
				local disable_type = {}
				local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
				if table_contains(disable_type, filetype) then
					return true
				end
				local buf_name = vim.api.nvim_buf_get_name(bufnr)
				local file_size = vim.api.nvim_call_function("getfsize", { buf_name })
				return file_size > 256 * 1024
			end,
			-- disable = { "org", "tex", "latex" }, -- note connot remove org
			-- disable = {},
			keybindings = {
				toggle_query_editor = "o",
				toggle_hl_groups = "i",
				toggle_injected_languages = "t",
				toggle_anonymous_nodes = "a",
				toggle_language_display = "I",
				focus_language = "f",
				unfocus_language = "F",
				update = "R",
				goto_node = "<cr>",
				show_help = "?",
			},
		},

		rainbow = {
			enable = true,
			disable = function(_, bufnr)
				local disable_type = {}
				local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
				if table_contains(disable_type, filetype) then
					return true
				end
				local buf_name = vim.api.nvim_buf_get_name(bufnr)
				local file_size = vim.api.nvim_call_function("getfsize", { buf_name })
				return file_size > 256 * 1024
			end,

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
end)
