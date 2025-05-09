return function()
	local secret_key = os.getenv("CODE_COMPANION_KEY")

	local available_models = {
		"qwen/qwq-32b:free",
		"qwen/qwen3-4b:free",
		"deepseek/deepseek-v3-base:free",
		"deepseek/deepseek-prover-v2:free",
		"meta-llama/llama-4-scout:free",
	}
	local default_model = "qwen/qwq-32b:free"
	local current_model = default_model
	local function select_model()
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")
		local finder = require("telescope.finders")
		local pickers = require("telescope.pickers")
		local type = require("telescope.themes").get_dropdown()
		local conf = require("telescope.config").values

		pickers
			.new(type, {
				prompt_title = "(CodeCompanion) Select Model",
				finder = finder.new_table({ results = available_models }),
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
	})

	vim.keymap.set({ "n", "v" }, "<leader>ck", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
	vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
	vim.keymap.set("v", "<leader>ca", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>cs", select_model, { desc = "Select CodeCompanion Models" })
end
