return function()
	require("modules.utils").load_plugin("fcitx5", {
		log = "warn",
		remember_prior = true,
		define_autocmd = true,
	})
end
