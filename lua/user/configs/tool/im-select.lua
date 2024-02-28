return function() -- This file MUST return a function accepting no parameter and has no return value
	local global = require("core.global")
	if global.is_mac then
		vim.api.nvim_command([[let g:im_select_get_im_cmd = ["im-select"] ]])
		vim.api.nvim_command([[let g:im_select_default = "com.apple.keylayout.US"]])
		vim.api.nvim_command([[let g:ImSelectSetImCmd = {key -> ["im-select", key]}]])
		vim.api.nvim_command([[let g:im_select_enable_focus_events = 0]])
	elseif vim.fn.executable("fcitx5-remote") == 1 then
		-- fcitx5 need a manual config
		vim.api.nvim_cmd({
			[[ let g:im_select_get_im_cmd = ["fcitx5-remote"] ]],
			[[ let g:im_select_default = '1' ]],
			[[ let g:ImSelectSetImCmd = {
			\ key ->
			\ key == 1 ? ['fcitx5-remote', '-c'] :
			\ key == 2 ? ['fcitx5-remote', '-o'] :
			\ key == 0 ? ['fcitx5-remote', '-c'] :
			\ execute("throw 'invalid im key'")
			\ }
			]],
		}, { true, true, true })
	end
end
