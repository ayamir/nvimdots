return function()
	local icons = { ui = require("modules.utils.icons").get("ui") }
	local close_func = function(bufnum)
		local bufdelete_avail, bufdelete = pcall(require, "bufdelete")
		if bufdelete_avail then
			bufdelete.bufdelete(bufnum, true)
		else
			vim.cmd.bdelete({ args = { bufnum }, bang = true })
		end
	end

	local opts = {
		options = {
			number = nil,
			buffer_close_icon = icons.ui.Close,
			close_command = close_func,
			right_mouse_command = close_func,
			left_trunc_marker = icons.ui.Left,
			right_trunc_marker = icons.ui.Right,
			max_name_length = 20,
			max_prefix_length = 13,
			tab_size = 20,
			color_icons = true,
			show_buffer_icons = true,
			show_buffer_close_icons = true,
			show_close_icon = true,
			show_tab_indicators = true,
			enforce_regular_tabs = false,
			persist_buffer_sort = true,
			always_show_bufferline = true,
			separator_style = "thin",
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(_, _, diagnostics)
				local result = {}
				local symbols = {
					error = " ",
					warning = " ",
					info = " ",
				}
				for name, count in pairs(diagnostics) do
					if symbols[name] and count > 0 then
						table.insert(result, symbols[name] .. count)
					end
				end
				local res = table.concat(result, " ")
				return #res > 0 and res or ""
			end,

			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					text_align = "center",
					padding = 0,
				},
				-- {
				-- 	filetype = "neo-tree",
				-- 	text = "File Explorer",
				-- 	text_align = "center",
				-- 	padding = 0,
				-- },
				{
					filetype = "lspsagaoutline",
					text = "Lspsaga Outline",
					text_align = "center",
					padding = 0,
				},
			},
		},
		-- Change bufferline's highlights here! See `:h bufferline-highlights` for detailed explanation.
		-- Note: If you use catppuccin then modify the colors below!
		highlights = {},
	}

	if vim.g.colors_name:find("catppuccin") then
		local cp = require("modules.utils").get_palette() -- Get the palette.

		local catppuccin_hl_overwrite = {
			highlights = require("catppuccin.groups.integrations.bufferline").get({
				styles = { "italic", "bold" },
				custom = {
					all = {
						-- Hint
						hint = { fg = cp.rosewater },
						hint_visible = { fg = cp.rosewater },
						hint_selected = { fg = cp.rosewater },
						hint_diagnostic = { fg = cp.rosewater },
						hint_diagnostic_visible = { fg = cp.rosewater },
						hint_diagnostic_selected = { fg = cp.rosewater },
					},
				},
			}),
		}

		opts = vim.tbl_deep_extend("force", opts, catppuccin_hl_overwrite)
	end

	require("bufferline").setup(opts)
end
