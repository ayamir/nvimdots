local M = require("lualine.component"):extend()
local icons = { aichat = require("modules.utils.icons").get("aichat", true) }

M.processing = false
M.spinner_index = 1

local spinners = {
	"⠋",
	"⠙",
	"⠹",
	"⠸",
	"⠼",
	"⠴",
	"⠦",
	"⠧",
	"⠇",
	"⠏",
}

-- Initializer
function M:init(options)
	M.super.init(self, options)

	local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = "CodeCompanionRequest*",
		group = group,
		callback = function(request)
			if request.match == "CodeCompanionRequestStarted" then
				self.processing = true
			elseif request.match == "CodeCompanionRequestFinished" then
				self.processing = false
			end
		end,
	})
end

-- Function that runs every time statusline is updated
function M:update_status()
	if self.processing then
		self.spinner_index = (self.spinner_index % #spinners) + 1
		return string.format("%s %s", icons.aichat.Copilot, spinners[self.spinner_index])
	else
		return nil
	end
end

return M
