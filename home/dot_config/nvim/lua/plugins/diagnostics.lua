return {
    {
        -- Preview code with LSP code actions applied.
        "aznhe21/actions-preview.nvim",
        event = "VeryLazy",
        opts = {
            diff = {
                algorithm = "patience",
            },
            telescope = {
                sorting_strategy = "ascending",
                layout_strategy = "vertical",
                layout_config = {
                    width = 0.8,
                    height = 0.9,
                    prompt_position = "top",
                    preview_cutoff = 20,
                    preview_height = function(_, _, max_lines)
                        return max_lines - 15
                    end,
                },
            },
        },
    },
    {
        -- AI/search-engine powered diagnostic debugging
        "piersolenski/wtf.nvim",
        opts = {
            popup_type = "vertical",
        },
        cmd = { "WtfSearch", "Wtf" },
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
    },
    {
        -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
        "folke/trouble.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        cmd = { "Trouble", "TroubleToggle", "TodoTrouble" },
        config = function()
            require("trouble").setup({})
        end,
        lazy = false,
        keys = {
            {
                "<leader>tb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble Buffer diagnostics"},
            {"<leader>td", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble Toggle diagnostics"},
            {"<leader>ts",  "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Trouble Symbols"},
            {"<leader>tl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "Trouble LSP Definitions / references"},
            {"<leader>tL", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble Location List"},
            {"<leader>tQ", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble Quickfix List"},
        },
    },
    {
        -- typos.nvim is a Neovim plugin that uses the typos-cli tool as a diagnostics source
        "poljar/typos.nvim",
        lazy = false
    },
}
