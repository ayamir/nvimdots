return function()
	local icons = { aichat = require("modules.utils.icons").get("aichat", true) }
	local secret_key = require("core.settings").chat_api_key
	local chat_lang = require("core.settings").chat_lang
	local models = require("core.settings").chat_models
	local current_model = models[1]
	vim.g.current_chat_model = current_model

	require("modules.utils").load_plugin("codecompanion", {
		opts = {
			language = chat_lang,
		},
		strategies = {
			chat = {
				adapter = "openrouter",
				roles = {
					llm = function(adapter)
						return icons.aichat.Copilot .. "CodeCompanion (" .. adapter.formatted_name .. ")"
					end,
					user = icons.aichat.Me .. "Me",
				},
				keymaps = {
					submit = {
						modes = { n = "<CR>" },
						description = "Submit",
						callback = function(chat)
							chat:submit()
						end,
					},
				},
			},
			inline = {
				adapter = "openrouter",
			},
			cmd = {
				adapter = "openrouter",
			},
		},
		adapters = {
			http = {
				openrouter = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = "https://openrouter.ai/api",
							api_key = secret_key,
							chat_url = "/v1/chat/completions",
						},
						schema = {
							model = {
								default = vim.g.current_chat_model,
							},
						},
					})
				end,
			},
		},
		display = {
			diff = {
				enabled = true,
				provider = "inline", -- mini_diff|split|inline
				provider_opts = {
					inline = {
						layout = "float", -- float|buffer
					},
				},
				split = {
					close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
					layout = "vertical", -- vertical|horizontal split
					opts = {
						"internal",
						"filler",
						"closeoff",
						"algorithm:histogram", -- https://adamj.eu/tech/2024/01/18/git-improve-diff-histogram/
						"indent-heuristic", -- https://blog.k-nut.eu/better-git-diffs
						"followwrap",
						"linematch:120",
					},
				},
			},
			chat = {
				window = {
					auto_scroll = true,
					border = "single",
					full_height = true, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
					layout = "vertical", -- float|vertical|horizontal|buffer
					position = "right", -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
					relative = "editor",
					show_header_separator = true,
					width = 0.25,
				},
			},
		},
		rules = {
			default = {
				description = "Collection of common files for all projects",
				files = {
					".clinerules",
					".cursorrules",
					".goosehints",
					".rules",
					".windsurfrules",
					".github/copilot-instructions.md",
					"AGENT.md",
					"AGENTS.md",
					{ path = "CLAUDE.md", parser = "claude" },
					{ path = "CLAUDE.local.md", parser = "claude" },
					{ path = "~/.claude/CLAUDE.md", parser = "claude" },
				},
				is_preset = true,
			},
			opts = {
				chat = {
					autoload = "default", -- The rule groups to load
					enabled = true,
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
end
