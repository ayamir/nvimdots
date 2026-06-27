local M = {}

local function get_settings()
	return require("core.settings")
end

function M.get_adapter(name)
	local settings = get_settings()
	local adapters = settings.ai_adapters or {}
	return adapters[name]
end

function M.get_adapter_api_key(adapter)
	local settings = get_settings()
	return adapter.api_key or settings["ai-api-key"] or settings.ai_api_key
end

function M.get_adapter_endpoint(adapter)
	return (adapter.base_url or "") .. (adapter.chat_url or "")
end

function M.get_adapter_models(adapter)
	return adapter.models or {}
end

function M.get_adapter_default_model(adapter)
	local models = M.get_adapter_models(adapter)
	return adapter.default_model or models[1]
end

function M.get_codecompanion_adapter_name()
	local settings = get_settings()
	return settings["codecompanion-adapter"] or settings.codecompanion_adapter or "openrouter"
end

function M.get_prediction_adapter_name()
	local settings = get_settings()
	return settings["pred-adapter"] or settings.pred_adapter or M.get_codecompanion_adapter_name()
end

function M.get_codecompanion_models()
	local adapter = M.get_adapter(M.get_codecompanion_adapter_name())
	if adapter then
		return M.get_adapter_models(adapter)
	end

	return {}
end

function M.get_codecompanion_default_model()
	local adapter = M.get_adapter(M.get_codecompanion_adapter_name())
	if adapter then
		return M.get_adapter_default_model(adapter)
	end

	return nil
end

function M.get_prediction_config()
	local settings = get_settings()
	local adapter = M.get_adapter(M.get_prediction_adapter_name())
	local pred_model = settings["pred-model"] or settings.pred_model
	local pred_optional_params = settings["pred-optional-params"] or settings.pred_optional_params or {}

	if adapter and adapter.type == "openai-compatible" then
		return {
			api_key = M.get_adapter_api_key(adapter),
			end_point = M.get_adapter_endpoint(adapter),
			model = pred_model or M.get_adapter_default_model(adapter),
			name = adapter.name or M.get_prediction_adapter_name(),
			optional = vim.tbl_deep_extend("force", adapter.optional or {}, pred_optional_params),
		}
	end

	return nil
end

return M
