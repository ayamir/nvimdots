local M = {}

M["opts"] = function()
	vim.g["suda#prompt"] = "Enter administrator password: "
end

M["config"] = function()
    return true
end

return M