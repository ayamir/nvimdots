local M = {}

M["reset"] = {
    -- "lazy",
    -- "buf",
    -- "wins",
    -- "ft",
    -- "yank",
}
-- If you want to add an autocmd, you can create one from the function below
-- vim.api.nvim_create_autocmd()
-- custom augroup
M["merge"] = {
	lazy = {},
	bufs = {},
	wins = {},
	ft = {},
	yank = {},
}

return M