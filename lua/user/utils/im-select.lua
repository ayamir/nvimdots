local M = {}
local Windows = {}
local Mac = {}

local xiaoheIM = "com.tencent.inputmethod.wetype.pinyin"
local defaultIM = "com.apple.keylayout.US"

Mac.zhCH = xiaoheIM
Mac.en = defaultIM

Windows.pingyinIM = "2052"
Windows.englishIM = "1033"
Windows.leaveVimIM = Windows.englishIM

local getChangeIM = function()
	local mode = vim.fn.mode()
	if mode == "n" then
		-- 当前为 normal 模式
		return Mac.en
	elseif mode == "i" then
		-- 当前为 insert 模式
		return Mac.zhCH
	elseif mode == "v" then
		-- 当前为 visual 模式
	end
end
