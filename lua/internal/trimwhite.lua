-- Trims trailing whitespace in the current buffer.
-- Also performs 'inccommand' preview if invoked as a preview callback
-- (preview_ns is non-nil).
local function trim_space(opts, preview_ns, preview_buf)
    local line1 = opts.line1
    local line2 = opts.line2
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, 0)
    local new_lines = {}
    local preview_buf_line = 0
    for i, line in ipairs(lines) do
        local startidx, endidx = string.find(line, "%s+$")
        if startidx ~= nil then
            -- Highlight the match if in command preview mode
            if preview_ns ~= nil then
                vim.api.nvim_buf_add_highlight(
                    buf,
                    preview_ns,
                    "Substitute",
                    line1 + i - 2,
                    startidx - 1,
                    endidx
                )
                -- Add lines and highlight to the preview buffer
                -- if inccommand=split
                if preview_buf ~= nil then
                    local prefix = string.format("|%d| ", line1 + i - 1)
                    vim.api.nvim_buf_set_lines(
                        preview_buf,
                        preview_buf_line,
                        preview_buf_line,
                        0,
                        { prefix .. line }
                    )
                    vim.api.nvim_buf_add_highlight(
                        preview_buf,
                        preview_ns,
                        "Substitute",
                        preview_buf_line,
                        #prefix + startidx - 1,
                        #prefix + endidx
                    )
                    preview_buf_line = preview_buf_line + 1
                end
            end
        end
        if not preview_ns then
            new_lines[#new_lines + 1] = string.gsub(line, "%s+$", "")
        end
    end
    -- Don't make any changes to the buffer if previewing
    if not preview_ns then
        vim.api.nvim_buf_set_lines(buf, line1 - 1, line2, 0, new_lines)
    end
    -- When called as a preview callback, return the value of the
    -- preview type
    if preview_ns ~= nil then
        return 2
    end
end

if vim.fn.has("nvim-0.8") == 1 then
    -- Create the user command
    vim.api.nvim_create_user_command(
        "TrimTrailingWhitespace",
        trim_space,
        { nargs = "?", range = "%", addr = "lines", preview = trim_space }
    )
end
