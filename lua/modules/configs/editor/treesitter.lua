return vim.schedule_wrap(function()
	local use_ssh = require("core.settings").use_ssh

	vim.api.nvim_set_option_value("foldmethod", "expr", {})
	vim.api.nvim_set_option_value("foldexpr", "nvim_treesitter#foldexpr()", {})

	require("modules.utils").load_plugin("nvim-treesitter", {
		ensure_installed = require("core.settings").treesitter_deps,
		highlight = {
			enable = true,
			disable = function(ft, bufnr)
				if
					vim.tbl_contains({ "gitcommit" }, ft)
					or (vim.api.nvim_buf_line_count(bufnr) > 7500 and ft ~= "vimdoc")
				then
					return true
				end

				local ok, is_large_file = pcall(vim.api.nvim_buf_get_var, bufnr, "bigfile_disable_treesitter")
				return ok and is_large_file
			end,
			additional_vim_regex_highlighting = false,
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true,
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
		indent = { enable = true },
		matchup = { enable = true },
	}, false, require("nvim-treesitter.configs").setup)
	require("nvim-treesitter.install").prefer_git = true
	if use_ssh then
		local parsers = require("nvim-treesitter.parsers").get_parser_configs()
		for _, parser in pairs(parsers) do
			parser.install_info.url = parser.install_info.url:gsub("https://github.com/", "git@github.com:")
		end
	end
end)
