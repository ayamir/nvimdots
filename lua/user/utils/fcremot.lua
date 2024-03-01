---
local input_toggle = 1

local autocmd = vim.api.nvim_create_autocmd

local Mac = {}
local defaultIM = "com.apple.keylayout.US"
local xiaoheIM = "com.tencent.inputmethod.wetype.pinyin"

Mac.en = defaultIM
Mac.zhCH = xiaoheIM

function DefaultIM()
	local input_status = tonumber(io.popen("fcitx-remote"):read("*all"))
	print(input_status)
	if input_status == 2 then
		input_toggle = 1
		-- vim.cmd(":silent :!im-select" .. " " .. Mac.en)
	end
end

vim.api.nvim_create_autocmd("InsertLeave", { pattern = "*", command = "lua DefaultIM()" })
-- autocmd("insertEnter", { pattern = "*", command = "DefaultIM" })
-- autocmd("insertLeave", { pattern = "*", command = "DefaultIM" })
