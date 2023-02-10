return function()
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
		on_open = function()
			-- Prevent infinite calls from freezing neovim.
			-- Only set these options specific to this terminal buffer.
			vim.api.nvim_set_option_value("foldmethod", "manual", { scope = "local" })
			vim.api.nvim_set_option_value("foldexpr", "0", { scope = "local" })
		end,
		highlights = {
			FloatBorder = {
				guifg = floatborder_hl,
			},
		},
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

	local function not_found_notify(program)
		vim.notify(string.format("[%s] not found!", program), vim.log.levels.ERROR, { title = "toggleterm.nvim" })
	end

	local Terminal = require("toggleterm.terminal").Terminal

	function _Lazygit_toggle()
		if vim.fn.executable("lazygit") then
			local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
			lazygit:toggle()
		else
			not_found_notify("Lazygit")
		end
	end

	function _Htop_toggle()
		if vim.fn.executable("lazygit") then
			local htop = Terminal:new({ cmd = "htop", hidden = true, direction = "float" })
			htop:toggle()
		else
			not_found_notify("Htop")
		end
	end

	function _Python_toggle()
		if vim.fn.executable("python3") then
			local python = Terminal:new({ cmd = "python3", hidden = true, direction = "float" })
			python:toggle()
		elseif vim.fn.executable("python") then
			local python = Terminal:new({ cmd = "python", hidden = true, direction = "float" })
			python:toggle()
		else
			not_found_notify("Python")
		end
	end
end
