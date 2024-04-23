return function()
	require("Navigator").setup({})
	vim.keymap.set("n", "<C-h>", "<CMD>NavigatorLeft<CR>")
	vim.keymap.set("n", "<C-l>", "<CMD>NavigatorRight<CR>")
	vim.keymap.set("n", "<C-k>", "<CMD>NavigatorUp<CR>")
	vim.keymap.set("n", "<C-j>", "<CMD>NavigatorDown<CR>")
end
