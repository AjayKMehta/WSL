local U = require("multicursors.utils")

local config = {
    -- Uncomment if want to show in lualine instead
    -- hint_config = false,
    hint_config = {
        float_opts = {
            border = "none",
        },
        position = "bottom-right",
    },
    generate_hints = {
        normal = true,
        insert = true,
        extend = true,
        config = {
            column_count = 1,
        },
    },
    normal_keys = {
        ["/"] = {
            method = function()
                U.call_on_selections(function(selection)
                    vim.api.nvim_win_set_cursor(0, { selection.row + 1, selection.col + 1 })
                    local line_count = selection.end_row - selection.row + 1
                    vim.cmd("normal " .. line_count .. "gcc")
                end)
            end,
            opts = { desc = "comment selections" },
        },
    },
}

require("multicursors").setup(config)
