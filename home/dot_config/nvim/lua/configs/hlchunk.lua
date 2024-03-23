local status_ok, hlchunk = pcall(require, "hlchunk")
if not status_ok then
    return
end
local ft = require("hlchunk.utils.filetype")

local exclude_filetypes = vim.tbl_deep_extend("force", ft.exclude_filetypes, {
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
            { fg = "#855cc4" }, -- fg = "#87afaf"
            { fg = "#c21f30" }, -- this fg is used to highlight wrong chunk
        },
        textobject = "",
        max_file_size = 1024 * 1024,
        error_sign = true,
    },
    indent = {
        enable = true,
        use_treesitter = false,
        -- more codes can be found at https://unicodeplus.com/
        chars = { "┃", "│", "¦", "┆", "┊" },
        -- https://github.com/lukas-reineke/indent-blankline.nvim#rainbow-delimitersnvim-integration
        style = {
            "#E06C75",
            "#E5C07B",
            "#61AFEF",
            "#D19A66",
            "#98C379",
            "#C678DD",
            "#56B6C2",
        },
        exclude_filetypes = exclude_filetypes,
    },
    line_num = {
        enable = true,
        use_treesitter = true,
        -- Doesn't support different styles for diff. levels like indent
        style = "#806d9c", -- fg = "#87afaf"
        support_filetypes = ft.support_filetypes,
    },
    blank = {
        exclude_filetypes = exclude_filetypes,
    },
})
