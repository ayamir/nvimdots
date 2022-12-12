local config = {}

function config.gruvbox_material()
    vim.opt.background = "dark"
    vim.g.gruvbox_material_background = "soft"
    vim.g.gruvbox_material_foreground = "material"
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_transp_bg = 1
    vim.g.gruvbox_material_disable_italic_comment = 0
    vim.g.gruvbox_material_better_performance = 1
    vim.g.gruvbox_plugin_hi_groups = 1
    vim.g.gruvbox_filetype_hi_groups = 1
end

return config
