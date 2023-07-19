return function()
	local status_ok, hints = pcall(require, "lsp-inlayhints")
	if not status_ok then
		return
	end

	local group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
	vim.api.nvim_create_autocmd({ "LspAttach" }, {
		group = "LspAttach_inlayhints",
		callback = function(args)
			if not (args.data and args.data.client_id) then
				return
			end
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			require("lsp-inlayhints").on_attach(client, args.buf)
		end,
	})

	hints.setup({
		inlay_hints = {
			parameter_hints = {
				show = true,
				prefix = " ▪ ",
				separator = ", ",
				remove_colon_start = false,
				remove_colon_end = true,
			},
			type_hints = {
				-- type and other hints
				show = true,
				-- prefix = " ▪ ",
				prefix = " ▸ ",
				separator = ", ",
				remove_colon_start = false,
				remove_colon_end = false,
			},
			only_current_line = false,
			-- separator between types and parameter hints. Note that type hints are
			-- shown before parameter
			labels_separator = "  ",
			-- whether to align to the length of the longest line in the file
			max_len_align = false,
			-- padding from the left if max_len_align is true
			max_len_align_padding = 1,
			-- highlight group
			-- highlight = "LspInlayHint",
			highlight = "DiagnosticHint",
		},
		enabled_at_startup = true,

		debug_mode = false,
	})
end
