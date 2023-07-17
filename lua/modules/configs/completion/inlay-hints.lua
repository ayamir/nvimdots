return function()
	-- listed below are the default values
	local override = {
		inlay_hints = {
			parameter_hints = {
				show = true,
			},
			type_hints = {
				show = true,
			},
			label_formatter = function(tbl, kind, opts)
				if kind == 2 and not opts.parameter_hints.show then
					return ""
				elseif not opts.type_hints.show then
					return ""
				end

				return table.concat(tbl, ", ")
			end,
			virt_text_formatter = function(label, hint, opts, client_name)
				if client_name == "lua_ls" then
					if hint.kind == 2 then
						hint.paddingLeft = false
					else
						hint.paddingRight = false
					end
				end

				local vt = {}
				vt[#vt + 1] = hint.paddingLeft and { " ", "None" } or nil
				vt[#vt + 1] = { label, opts.highlight }
				vt[#vt + 1] = hint.paddingRight and { " ", "None" } or nil

				return vt
			end,
			only_current_line = false,
			-- highlight group
			highlight = "LspInlayHint",
			-- highlight = "Comment",
			-- virt_text priority
			priority = 0,
		},
		enabled_at_startup = true,
		debug_mode = false,
	}
	require("lsp-inlayhints").setup(override)
end
