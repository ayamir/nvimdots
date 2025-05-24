return function()
	local secret_key = os.getenv("CODE_COMPANION_KEY")
	local models = require("core.settings").chat_models
	local default_model = models[1]
	local current_model = default_model
	local icons = { aichat = require("modules.utils.icons").get("aichat", true) }

	local select_model = function()
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")
		local finder = require("telescope.finders")
		local pickers = require("telescope.pickers")
		local type = require("telescope.themes").get_dropdown()
		local conf = require("telescope.config").values

		pickers
			.new(type, {
				prompt_title = "(CodeCompanion) Select Model",
				finder = finder.new_table({ results = models }),
				sorter = conf.generic_sorter(type),
				attach_mappings = function(bufnr)
					actions.select_default:replace(function()
						actions.close(bufnr)
						current_model = action_state.get_selected_entry()[1]
						vim.notify(
							"Model selected: " .. current_model,
							vim.log.levels.INFO,
							{ title = "CodeCompanion" }
						)
					end)

					return true
				end,
			})
			:find()
	end

	require("modules.utils").load_plugin("codecompanion", {
		strategies = {
			chat = {
				adapter = "openrouter",
				roles = {
					llm = function(adapter)
						return icons.aichat.Copilot .. "CodeCompanion (" .. adapter.formatted_name .. ")"
					end,
					user = icons.aichat.Me .. "Me",
				},
			},
			inline = {
				adapter = "openrouter",
			},
		},
		adapters = {
			openrouter = function()
				return require("codecompanion.adapters").extend("openai_compatible", {
					env = {
						url = "https://openrouter.ai/api",
						api_key = secret_key,
						chat_url = "/v1/chat/completions",
					},
					schema = {
						model = {
							default = current_model,
						},
					},
				})
			end,
		},
		display = {
			diff = {
				enabled = true,
				close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
				layout = "vertical", -- vertical|horizontal split for default provider
				opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
				provider = "default", -- default|mini_diff
			},
			chat = {
				window = {
					layout = "vertical", -- float|vertical|horizontal|buffer
					position = "right", -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
					border = "single",
					width = 0.25,
					relative = "editor",
					full_height = true, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
				},
			},
		},
		extensions = {
			history = {
				enabled = true,
				opts = {
					-- Keymap to open history from chat buffer (default: gh)
					keymap = "gh",
					-- Automatically generate titles for new chats
					auto_generate_title = true,
					---On exiting and entering neovim, loads the last chat on opening chat
					continue_last_chat = false,
					---When chat is cleared with `gx` delete the chat from history
					delete_on_clearing_chat = false,
					-- Picker interface ("telescope", "snacks" or "default")
					picker = "telescope",
					---Enable detailed logging for history extension
					enable_logging = false,
					---Directory path to save the chats
					dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
					-- Save all chats by default
					auto_save = true,
					-- Keymap to save the current chat manually
					save_chat_keymap = "sc",
					-- Number of days after which chats are automatically deleted (0 to disable)
					expiration_days = 0,
				},
			},
		},
	})

	vim.keymap.set("n", "<leader>cs", select_model, { desc = "Select CodeCompanion Models" })
end
