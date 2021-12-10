local fn, uv, api = vim.fn, vim.loop, vim.api
local vim_path = require("core.global").vim_path
local data_dir = require("core.global").data_dir
local modules_dir = vim_path .. "/lua/modules"
local packer_compiled = data_dir .. "packer_compiled.vim"
local compile_to_lua = data_dir .. "lua/_compiled.lua"
local bak_compiled = data_dir .. "lua/bak_compiled.lua"
local packer = nil

local Packer = {}
Packer.__index = Packer

function Packer:load_plugins()
    self.repos = {}

    local get_plugins_list = function()
        local list = {}
        local tmp = vim.split(fn.globpath(modules_dir, "*/plugins.lua"), "\n")
        for _, f in ipairs(tmp) do
            list[#list + 1] = f:sub(#modules_dir - 6, -1)
        end
        return list
    end

    local plugins_file = get_plugins_list()
    for _, m in ipairs(plugins_file) do
        local repos = require(m:sub(0, #m - 4))
        for repo, conf in pairs(repos) do
            self.repos[#self.repos + 1] = vim.tbl_extend("force", {repo}, conf)
        end
    end
end

function Packer:load_packer()
    if not packer then
        api.nvim_command("packadd packer.nvim")
        packer = require("packer")
    end
    packer.init({
        compile_path = packer_compiled,
        git = {clone_timeout = 120},
        disable_commands = true,
        max_jobs = 20,
        display = {
            open_fn = function()
                return require("packer.util").float({border = "single"})
            end
        }
    })
    packer.reset()
    local use = packer.use
    self:load_plugins()
    use {"wbthomason/packer.nvim", opt = true}
    for _, repo in ipairs(self.repos) do use(repo) end
end

function Packer:init_ensure_plugins()
    local packer_dir = data_dir .. "pack/packer/opt/packer.nvim"
    local state = uv.fs_stat(packer_dir)
    if not state then
        local cmd = "!git clone https://github.com/wbthomason/packer.nvim " ..
                        packer_dir
        api.nvim_command(cmd)
        uv.fs_mkdir(data_dir .. "lua", 511,
                    function() assert("make compile path dir faield") end)
        self:load_packer()
        packer.install()
    end
end

local plugins = setmetatable({}, {
    __index = function(_, key)
        if not packer then Packer:load_packer() end
        return packer[key]
    end
})

function plugins.ensure_plugins() Packer:init_ensure_plugins() end

function plugins.convert_compile_file()
    local lines = {}
    local lnum = 1
    lines[#lines + 1] = "vim.cmd [[packadd packer.nvim]]\n"

    for line in io.lines(packer_compiled) do
        lnum = lnum + 1
        if lnum > 15 then
            lines[#lines + 1] = line .. "\n"
            if line == "END" then break end
        end
    end
    table.remove(lines, #lines)

    if vim.fn.isdirectory(data_dir .. "lua") ~= 1 then
        os.execute("mkdir -p " .. data_dir .. "lua")
    end

    if vim.fn.filereadable(compile_to_lua) == 1 then
        os.rename(compile_to_lua, bak_compiled)
    end

    local file = io.open(compile_to_lua, "w")
    for _, line in ipairs(lines) do file:write(line) end
    file:close()

    os.remove(packer_compiled)
end

function plugins.magic_compile()
    plugins.compile()
    plugins.convert_compile_file()
end

function plugins.auto_compile()
    local file = vim.fn.expand("%:p")
    if file:match(modules_dir) then
        plugins.clean()
        plugins.compile()
        plugins.convert_compile_file()
    end
end

function plugins.load_compile()
    if vim.fn.filereadable(compile_to_lua) == 1 then
        require("_compiled")
    else
        assert(
            "Missing packer compile file Run PackerCompile Or PackerInstall to fix")
    end
    vim.cmd [[command! PackerCompile lua require('core.pack').magic_compile()]]
    vim.cmd [[command! PackerInstall lua require('core.pack').install()]]
    vim.cmd [[command! PackerUpdate lua require('core.pack').update()]]
    vim.cmd [[command! PackerSync lua require('core.pack').sync()]]
    vim.cmd [[command! PackerClean lua require('core.pack').clean()]]
    vim.cmd [[autocmd User PackerComplete lua require('core.pack').magic_compile()]]
    vim.cmd [[command! PackerStatus lua require('core.pack').magic_compile() require('packer').status()]]
end

return plugins
