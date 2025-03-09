return {
    {
        -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
        "folke/trouble.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        cmd = { "Trouble", "TroubleToggle", "TodoTrouble" },
        config = function()
            dofile(vim.g.base46_cache .. "trouble")
            require("trouble").setup({
                modes = {
                    preview_float = {
                        mode = "diagnostics",
                        preview = {
                            type = "float",
                            relative = "editor",
                            border = "rounded",
                            title = "Preview",
                            title_pos = "center",
                            position = { 0, -2 },
                            size = { width = 0.3, height = 0.3 },
                            zindex = 200,
                        },
                    },
                },
            })
        end,
        lazy = false,
        keys = {
            {
                "<leader>tb",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Trouble Buffer diagnostics",
            },
            { "<leader>td", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble Toggle diagnostics" },
            { "<leader>ts", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Trouble Symbols" },
            {
                "<leader>tl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "Trouble LSP Definitions / references",
            },
            { "<leader>tL", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble Location List" },
            { "<leader>tQ", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble Quickfix List" },
        },
    },
}
