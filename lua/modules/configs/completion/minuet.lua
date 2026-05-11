return function()
	local settings = require("core.settings")
	local openai_endpoint = settings["openai-endpoint"] or settings.openai_endpoint
	local pred_model = settings["pred-model"] or settings.pred_model
	local pred_optional_params = settings["pred-optional-params"] or settings.pred_optional_params

	require("modules.utils").load_plugin("minuet", {
		provider = "openai_compatible",
		provider_options = {
			openai_compatible = {
				api_key = settings.chat_api_key,
				end_point = openai_endpoint,
				model = pred_model,
				name = "OpenAI Compatible",
				optional = pred_optional_params,
			},
		},
	})
end
