_G._command_panel = function()
	require("telescope.builtin").keymaps({
		lhs_filter = function(lhs)
			return not string.find(lhs, "Þ")
		end,
	})
end

_G._flash_esc_or_noh = function()
	local flash_active, state = pcall(function()
		return require("flash.plugins.char").state
	end)
	if flash_active and state then
		state:hide()
	else
		pcall(vim.cmd.noh)
	end
end

_G._telescope_collections = function(opts)
	local tabs = require("search.tabs")
	local actions = require("telescope.actions")
	local state = require("telescope.actions.state")
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local collections = vim.tbl_keys(tabs.collections)

	-- build and launch picker
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "Telescope Collections",
			finder = finders.new_table({ results = collections }),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(bufnr)
				actions.select_default:replace(function()
					actions.close(bufnr)
					local selection = state.get_selected_entry()
					require("search").open({ collection = selection[1] })
				end)
				return true
			end,
		})
		:find()
end

_G._toggle_inlayhint = function()
	local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
	vim.lsp.inlay_hint.enable(not is_enabled)
	vim.notify(
		(is_enabled and "Inlay hint disabled successfully" or "Inlay hint enabled successfully"),
		vim.log.levels.INFO,
		{ title = "LSP Inlay Hint" }
	)
end

_G._toggle_virtuallines = function()
	require("tiny-inline-diagnostic").toggle()
	vim.notify(
		"Virtual lines are now "
			.. (require("tiny-inline-diagnostic.diagnostic").user_toggle_state and "displayed" or "hidden"),
		vim.log.levels.INFO,
		{ title = "LSP Diagnostic" }
	)
end

local _lazygit = nil
_G._toggle_lazygit = function()
	if vim.fn.executable("lazygit") == 1 then
		if not _lazygit then
			_lazygit = require("toggleterm.terminal").Terminal:new({
				cmd = "lazygit",
				direction = "float",
				close_on_exit = true,
				hidden = true,
			})
		end
		_lazygit:toggle()
	else
		vim.notify("Command [lazygit] not found!", vim.log.levels.ERROR, { title = "toggleterm.nvim" })
	end
end

_G._select_chat_model = function()
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local finder = require("telescope.finders")
	local pickers = require("telescope.pickers")
	local type = require("telescope.themes").get_dropdown()
	local conf = require("telescope.config").values
	local models = require("core.settings").chat_models
	local current_model = models[1]

	pickers
		.new(type, {
			prompt_title = "(CodeCompanion) Select Model",
			finder = finder.new_table({ results = models }),
			sorter = conf.generic_sorter(type),
			attach_mappings = function(bufnr)
				actions.select_default:replace(function()
					actions.close(bufnr)
					current_model = action_state.get_selected_entry()[1]
					vim.g.current_chat_model = current_model
					vim.notify("Model selected: " .. current_model, vim.log.levels.INFO, { title = "CodeCompanion" })
				end)

				return true
			end,
		})
		:find()
end
