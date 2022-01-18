local completion = {}

completion["neoclide/coc.nvim"] = {
    opt = true,
    event = "BufRead",
    branch = "release",
    config = function()
        vim.api.nvim_exec([[source ~/.config/nvim/lua/modules/completion/coc_config.vim]], false)
    end
}
completion["github/copilot.vim"] = {opt = true, cmd = "Copilot"}

return completion
