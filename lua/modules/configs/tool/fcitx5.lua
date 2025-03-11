return function()
	require("modules.utils").load_plugin("fcitx5", {
		log = "warn",
		define_autocmd = true,
		remember_prior = true,
	})
end
