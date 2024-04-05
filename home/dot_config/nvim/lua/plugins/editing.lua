return {
    -- Press " to see registers' contents
    { "junegunn/vim-peekaboo" },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvim-surround").setup({
                -- configuration here, or leave empty to use defaults
            })
        end,
    },
    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        config = function()
            require("better_escape").setup()
        end,
    },
    {
        -- Move lines and blocks of code
        "echasnovski/mini.move",
        version = false,
        opts = { options = { reindent_linewise = true } },
        event = "VeryLazy",
    },
    {
        -- highlight-undo will remap the u and <C-r> keys (for undo and redo, by default) to highlight changed text after Undo / Redo operations.
        "tzachar/highlight-undo.nvim",
        opts = {
            duration = 300,
            undo = {
                hlgroup = "HighlightUndo",
                mode = "n",
                lhs = "u",
                map = "undo",
                opts = {},
            },
            redo = {
                hlgroup = "HighlightUndo",
                mode = "n",
                lhs = "<C-r>",
                map = "redo",
                opts = {},
            },
            highlight_for_count = true,
        },
        event = { "BufReadPre" },
    },
}
