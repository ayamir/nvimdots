return function()
	vim.g["suda#prompt"] = "Enter administrator password: "

	require("modules.utils").load_plugin("suda", nil, true)
end
