local M = {}

function M.load_config(plugin)
    return function()
        require("configs." .. plugin)
    end
end

-- https://github.com/linrongbin16/lin.nvim/blob/c8e5ecbca422938a52126022b89395e93281c11c/lua/builtin/utils/layout.lua
M.get_width = function(percent, min_width, max_width)
    local editor_w = vim.o.columns
    local result = math.floor(editor_w * percent)
    if max_width then
        result = math.floor(math.min(max_width, result))
    end
    if min_width then
        result = math.floor(math.max(min_width, result))
    end
    return result
end

M.get_buf_name = function(buf)
    local max_name_len = M.get_width(0.334, 60, nil)
    local name = buf.name
    local len = name ~= nil and string.len(name) or 0
    if len > max_name_len then
        local half = math.floor(max_name_len / 2) - 1
        local left = string.sub(name, 1, half)
        local right = string.sub(name, len - half, len)
        name = left .. "…" .. right
    end
    return name
end

M.map = vim.keymap.set

-- First word in desc will be used for group heading in NvChad cheatsheet
M.map_desc = function(mode, keys, cmd, desc)
    return M.map(mode, keys, cmd, { desc = desc })
end

return M
