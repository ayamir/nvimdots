local M = {}

M.flash_esc_or_noh = function()
	local flash_active, state = pcall(function()
		return require("flash.plugins.char").state
	end)
	if flash_active and state then
		state:hide()
	else
		pcall(vim.cmd.noh)
	end
end

M.search_collections = function()
	require("search").collections()
end

M.toggle_inlayhint = function()
	local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
	vim.lsp.inlay_hint.enable(not is_enabled)
	vim.notify(
		(is_enabled and "Inlay hint disabled successfully" or "Inlay hint enabled successfully"),
		vim.log.levels.INFO,
		{ title = "LSP Inlay Hint" }
	)
end

M.toggle_virtuallines = function()
	require("tiny-inline-diagnostic").toggle()
	vim.notify(
		"Virtual lines are now "
			.. (require("tiny-inline-diagnostic.state").user_toggle_state and "displayed" or "hidden"),
		vim.log.levels.INFO,
		{ title = "LSP Diagnostic" }
	)
end

M.toggle_lazygit = function()
	if vim.fn.executable("lazygit") == 1 then
		require("nvchad.term").runner({
			id = "LazyGit",
			pos = "float",
			cmd = "lazygit",
		})
	else
		vim.notify("Command [lazygit] not found!", vim.log.levels.ERROR, { title = "NvChad term" })
	end
end

M.select_chat_model = function()
	local ai = require("modules.utils.ai")
	local models = ai.get_codecompanion_models()
	local items = vim.tbl_map(function(model)
		return { text = model }
	end, models)

	require("snacks").picker.pick({
		title = "(CodeCompanion) Select Model",
		items = items,
		format = function(item)
			return { { item.text } }
		end,
		layout = {
			preview = false,
			preset = "select",
		},
		confirm = function(picker, item)
			picker:close()
			if item then
				vim.g.current_chat_model = item.text
				vim.notify("Model selected: " .. item.text, vim.log.levels.INFO, { title = "CodeCompanion" })
			end
		end,
	})
end

M.picker = function(method, opts)
	require("snacks").picker[method](opts)
end

return M
