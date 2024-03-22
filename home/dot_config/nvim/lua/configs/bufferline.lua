local utils = require("utils")

--- comment
--- @param count integer total count of errors
--- @param level string "error | warning"
--- @param diagnostics_dict any "a dictionary from error level (error, warning or info) to number of errors for each level"
--- @param context any
---@return string
local function diag_ind(count, level, diagnostics_dict, context)
    local icon = level:match("error") and " " or " "
    -- Don't get too fancy as this function will be executed a lot
    return " " .. icon .. count
end

require("bufferline").setup({
    options = {
        themable = true,
        diagnostics_indicator = diag_ind,
        max_name_length = utils.get_width(0.334, 60, nil),
        max_prefix_length = utils.get_width(0.1, 10, 18),
        name_formatter = utils.get_buf_name,
    },
})
