local global = {}
local os_name = vim.uv.os_uname().sysname

function global:load_variables()
	self.is_mac = os_name == "Darwin"
	self.is_linux = os_name == "Linux"
	self.is_windows = os_name == "Windows_NT"
	self.is_wsl = vim.fn.has("wsl") == 1
	self.vim_path = vim.fn.stdpath("config")
	self.cache_dir = vim.fn.stdpath("cache")
	self.data_dir = string.format("%s/site/", vim.fn.stdpath("data"))
	self.modules_dir = self.vim_path .. "/modules"
	self.home = self.is_windows and vim.env.USERPROFILE or vim.env.HOME
end

global:load_variables()

return global
