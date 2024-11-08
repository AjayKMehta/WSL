local status_ok, hlchunk = require("utils").is_loaded("hlchunk")
if not status_ok then
    return
end
local ft = require("hlchunk.utils.filetype")

local exclude_filetypes = vim.tbl_deep_extend("force", ft.exclude_filetypes, {
    terminal = true,
    startify = true,
    FTerm = true,
    ["no-profile"] = true,
    nvcheatsheet = true,
    crunner = true,
    dropbar_menu = true,
    Outline = true,
    git = true,
    VoltWindow = true,
})

hlchunk.setup({
    chunk = {
        enable = true,
        notify = true,
        use_treesitter = false,
        -- details about support_filetypes and exclude_filetypes in https://github.com/shellRaining/hlchunk.nvim/blob/main/lua/hlchunk/utils/filetype.lua
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
            { fg = "#c21f30" }, -- highlight chunk with error
        },
        textobject = "iC",
        max_file_size = 1024 * 1024,
        error_sign = true,
    },
    indent = {
        enable = true,
        use_treesitter = false,
        ahead_lines = 10,
        -- more codes can be found at https://unicodeplus.com/
        chars = {  "┃", "│", "¦", "┆", "┊" , '|', "‖",},
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
    },
    blank = {
        exclude_filetypes = exclude_filetypes,
    },
})
