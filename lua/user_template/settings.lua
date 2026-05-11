-- Please check `lua/core/settings.lua` to view the full list of configurable settings
local settings = {}

-- Examples
settings["use_ssh"] = true

settings["colorscheme"] = "catppuccin"

settings["edit_prediction_source"] = "copilot"

settings["openai_endpoint"] = "https://openrouter.ai/api/v1/chat/completions"

settings["pred_model"] = "deepseek/deepseek-v4-flash"

settings["pred_optional_params"] = {
	max_tokens = 128,
}

return settings
