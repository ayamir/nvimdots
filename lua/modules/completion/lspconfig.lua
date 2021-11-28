if not packer_plugins["nvim-lspconfig"].loaded then
    vim.cmd [[packadd nvim-lspconfig]]
end

if not packer_plugins["nvim-lsp-installer"].loaded then
    vim.cmd [[packadd nvim-lsp-installer]]
end

if not packer_plugins["lsp_signature.nvim"].loaded then
    vim.cmd [[packadd lsp_signature.nvim]]
end

if not packer_plugins["lspsaga.nvim"].loaded then
    vim.cmd [[packadd lspsaga.nvim]]
end

local nvim_lsp = require("lspconfig")
local util = require("lspconfig/util")
local lsp_installer = require("nvim-lsp-installer")

lsp_installer.settings {
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
}

local capabilities = vim.lsp.protocol.make_client_capabilities()

nvim_lsp.ccls.setup{
    cmd = { "ccls" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    root_dir = function (name)
        return util.root_pattern("compile_commands.json", ".ccls", "compile_flags.txt", ".git")(name)
            or util.path.dirname(name)
    end
}

capabilities.textDocument.completion.completionItem.documentationFormat = {
    "markdown", "plaintext"
}
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport =
    true
capabilities.textDocument.completion.completionItem.tagSupport = {
    valueSet = {1}
}
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {"documentation", "detail", "additionalTextEdits"}
}

local function custom_attach()
    require("lsp_signature").on_attach({
        bind = true,
        use_lspsaga = false,
        floating_window = true,
        fix_pos = true,
        hint_enable = true,
        hi_parameter = "Search",
        handler_opts = {"double"}
    })
end

local function switch_source_header_splitcmd(bufnr, splitcmd)
    bufnr = nvim_lsp.util.validate_bufnr(bufnr)
    local params = {uri = vim.uri_from_bufnr(bufnr)}
    vim.lsp.buf_request(bufnr, "textDocument/switchSourceHeader", params,
                        function(err, result)
        if err then error(tostring(err)) end
        if not result then
            print("Corresponding file can’t be determined")
            return
        end
        vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
    end)
end

lsp_installer.on_server_ready(function(server)
    local opts = {}

    if (server.name == "sumneko_lua") then
        opts.settings = {
            Lua = {
                diagnostics = {globals = {"vim", "packer_plugins"}},
                workspace = {
                    library = {
                        [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                        [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true
                    },
                    maxPreload = 100000,
                    preloadFileSize = 10000
                },
                telemetry = {enable = false}
            }
        }
    elseif (server.name == "clangd") then
        opts.commands = {
            ClangdSwitchSourceHeader = {
                function()
                    switch_source_header_splitcmd(0, "edit")
                end,
                description = "Open source/header in current buffer"
            },
            ClangdSwitchSourceHeaderVSplit = {
                function()
                    switch_source_header_splitcmd(0, "vsplit")
                end,
                description = "Open source/header in a new vsplit"
            },
            ClangdSwitchSourceHeaderSplit = {
                function()
                    switch_source_header_splitcmd(0, "split")
                end,
                description = "Open source/header in a new split"
            }
        }
    end
    opts.capabilities = capabilities
    opts.flags = {debounce_text_changes = 500}
    opts.on_attach = custom_attach

    server:setup(opts)
end)
