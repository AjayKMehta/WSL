local utils = require("utils")
local _, chroma = pcall(require, "chromabuffer")

chroma.setup({ highlight_template = "default" })
local highlights = chroma.get_bufferline_highlights()

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
        diagnostics = "nvim_lsp",
        diagnostics_indicator = diag_ind,
        diagnostics_update_on_event = true,
        max_name_length = utils.get_width(0.334, 60, nil),
        max_prefix_length = utils.get_width(0.1, 10, 18),
        name_formatter = utils.get_buf_name,
        mode = "buffers",
        separator_style = "thin",
        always_show_bufferline = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        indicator = { style = "underline" },
    },
    highlights = {
        separator = {
            fg = highlights.separator_fg,
            bg = highlights.bg,
        },
        separator_selected = {
            fg = highlights.separator_fg,
        },
        background = {
            fg = highlights.background_fg,
            bg = highlights.bg,
        },
        buffer_selected = {
            fg = highlights.selected_fg,
            bold = true,
            italic = false,
        },
        fill = {
            bg = highlights.fill_bg,
        },
    },
})
