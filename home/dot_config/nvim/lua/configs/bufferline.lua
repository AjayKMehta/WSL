-- https://github.com/linrongbin16/lin.nvim/blob/c8e5ecbca422938a52126022b89395e93281c11c/lua/builtin/utils/layout.lua
local width = function(percent, min_width, max_width)
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

require("bufferline").setup({
    options = {
        themable = true,

        --- count is an integer representing total count of errors
        --- level is a string "error" | "warning"
        --- diagnostics_dict is a dictionary from error level ("error", "warning" or "info")to number of errors for each level.
        --- this should return a string
        --- Don't get too fancy as this function will be executed a lot
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
        end,
        max_name_length = width(0.334, 60, nil),
        max_prefix_length = width(0.1, 10, 18),
        name_formatter = function(buf)
            local max_name_len = width(0.334, 60, nil)
            local name = buf.name
            local len = name ~= nil and string.len(name) or 0
            if len > max_name_len then
                local half = math.floor(max_name_len / 2) - 1
                local left = string.sub(name, 1, half)
                local right = string.sub(name, len - half, len)
                name = left .. "…" .. right
            end
            return name
        end,
    },
})
