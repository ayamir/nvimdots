return function()
	require("scrollbar").setup({
		excluded_filetypes = {
			"cmp_docs",
			"cmp_menu",
			"noice",
			"prompt",
			"TelescopePrompt",
			"lazy",
		},
		exclude_func = function(winid, bufnr)
			if not vim.api.nvim_win_is_valid(winid) then
				return true
			end

			local is_floating = vim.api.nvim_win_get_config(winid).relative ~= ""

			local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
			local exclude_filetype = {
				TelescopePrompt = true,
				lspsagafinder = true,
				[""] = true,
			}

			local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
			local exclude_buftype = {
				terminal = true,
				prompt = true,
			}

			return is_floating or exclude_buftype[buftype] or exclude_filetype[filetype]
		end,
	})
	require("scrollbar.handlers.gitsigns").setup()
end
