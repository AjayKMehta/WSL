local status_ok, hlchunk = pcall(require, "hlchunk")
if not status_ok then
    return
end
local ft = require("hlchunk.utils.filetype")

local exclude_filetypes = vim.tbl_extend("force", ft.exclude_filetypes, {
    terminal = true,
    startify = true,
    FTerm = true,
    ["no-profile"] = true,
})

hlchunk.setup({
    chunk = {
        enable = true,
        notify = true,
        use_treesitter = true,
        -- details about support_filetypes and exclude_filetypes in https://github.com/shellRaining/hlchunk.nvim/blob/main/lua/hlchunk/utils/filetype.lua
        support_filetypes = ft.support_filetypes,
        exclude_filetypes = exclude_filetypes,
        chars = {
            horizontal_line = "─",
            vertical_line = "│",
            left_top = "╭",
            left_bottom = "╰",
            right_arrow = ">",
        },
        style = {
            { fg = "#806d9c" }, -- fg = "#87afaf"
            { fg = "#c21f30" }, -- this fg is used to highlight wrong chunk
        },
        textobject = "",
        max_file_size = 1024 * 1024,
        error_sign = true,
    },
    indent = {
        enable = true,
        use_treesitter = true,
        chars = {
            "│",
        },
        style = {
            "#FF0000",
            "#FF7F00",
            "#FFFF00",
            "#00FF00",
            "#00FFFF",
            "#0000FF",
            "#8B00FF",
        },
        exclude_filetypes = exclude_filetypes,
    },
    line_num = {
        enable = true,
        use_treesitter = true,
        style = "#806d9c", -- fg = "#87afaf"
        support_filetypes = ft.support_filetypes,
    },
    blank = {
        exclude_filetypes = exclude_filetypes,
    },
})
