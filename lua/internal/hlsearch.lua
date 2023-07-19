-- TODO: Won't stop search only symbols like "/"
local api, fn = vim.api, vim.fn
hs = {}
local group = api.nvim_create_augroup("Hlsearch", { clear = true })

function stop_hl()
    if vim.v.hlsearch == 0 then
        return
    end
    local keycode =
        api.nvim_replace_termcodes("<Cmd>nohl<CR>", true, false, true)
    api.nvim_feedkeys(keycode, "n", false)
end

function start_hl()
    local res = fn.getreg("/"):gsub("%*", "")
    -- local res_clean = res:gsub("%p+", { ["\\<"] = "", ["\\>"] = "" })
    local res_clean = res:gsub("[%p%c%s]", "")
    local cword = fn.expand("<cword>")
    cword = cword:gsub("[%p%c%s]", "")
    if vim.v.hlsearch == 1 and not fn.search([[\%#\zs]] .. res, "cnW") then
        stop_hl()
    end
    if
        not (
            string.find(string.lower(cword), string.lower(res_clean))
            or string.find(string.lower(res_clean), string.lower(cword))
        )
    then
        stop_hl()
    end
end

local function hs_event(bufnr)
    local cm_id = api.nvim_create_autocmd("CursorMoved", {
        buffer = bufnr,
        group = group,
        callback = function()
            start_hl()
        end,
        desc = "Auto hlsearch",
    })

    local ie_id = api.nvim_create_autocmd("InsertEnter", {
        buffer = bufnr,
        group = group,
        callback = function()
            stop_hl()
        end,
        desc = "Auto remove hlsearch",
    })

    api.nvim_create_autocmd("BufDelete", {
        buffer = bufnr,
        group = group,
        callback = function(opt)
            pcall(api.nvim_del_autocmd, cm_id)
            pcall(api.nvim_del_autocmd, ie_id)
            pcall(api.nvim_del_autocmd, opt.id)
        end,
    })
end

function hs.setup()
    api.nvim_create_autocmd("BufWinEnter", {
        group = group,
        callback = function(opt)
            hs_event(opt.buf)
        end,
        desc = "hlsearch.nvim event",
    })
end

-- hs.setup()
return hs
