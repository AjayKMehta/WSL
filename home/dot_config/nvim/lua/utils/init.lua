local M = {}

function M.load_config(plugin)
    return function()
        require("configs." .. plugin)
    end
end

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

M.is_image = function(filepath)
    local image_extensions = { "png", "jpg" } -- Supported image formats
    local split_path = vim.split(filepath:lower(), ".", { plain = true })
    local extension = split_path[#split_path]
    return vim.tbl_contains(image_extensions, extension)
end

M.has_filename = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
end

M.is_loaded = function(module)
    return pcall(require, module)
end

--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- @return function that can truncate text according to window width
--- @see https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#truncating-components-in-smaller-window
M.trunc = function(trunc_width, trunc_len, hide_width, no_ellipsis)
    return function(str)
        local win_width = vim.fn.winwidth(0)
        if hide_width and win_width < hide_width then
            return ""
        elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
            return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
        end
        return str
    end
end

return M
