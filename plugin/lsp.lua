local nvim_lsp = require('lspconfig')
local lsp_install = require('lspinstall')
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {'documentation', 'detail', 'additionalTextEdits'}
}

local function setup_servers()
    lsp_install.setup()
    local servers = lsp_install.installed_servers()
    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
            capabilities = capabilities,
            on_attach = function()
                require('lsp_signature').on_attach({
                    bind = true,
                    use_lspsaga = false,
                    floating_window = true,
                    fix_pos = true,
                    hint_enable = true,
                    hi_parameter = "Search",
                    handler_opts = {"double"}
                })
            end
        }
    end
end

lsp_install.post_install_hook = function()
    setup_servers() -- reload installed servers
    vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

setup_servers()
